package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.IdentityProvider;
import com.cdurgun.learning.domain.Role;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.domain.UserIdentity;
import com.cdurgun.learning.repository.UserIdentityRepository;
import com.cdurgun.learning.repository.UserRepository;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Google kimliklerini yerel hesaplara bağlayan tek yer. İki kural burada zorlanır:
 * (1) bir Google hesabı yerel bir hesaba YALNIZCA e-posta eşleşti diye bağlanmaz --
 * mevcut hesabın şifresi doğrulanmalıdır ({@link #link}); (2) yeni hesap YALNIZCA
 * kullanıcı Kullanım Koşulları'nı kabul ettikten sonra açılır ({@link #createAccount}),
 * ve {@code created_at} kayıt formundaki gibi o kabulün anıdır. Ayrıca ADMIN hesapları
 * Google'la hiç kullanılamaz ({@link #allowsGoogleSignIn}): ne bağlanır ne de mevcut bir
 * bağlantıyla giriş yapar -- yönetici girişi yalnızca şifreyle.
 */
@Service
public class GoogleAccountService {

    private static final int MAX_DISPLAY_NAME_LENGTH = 255;

    private final UserRepository userRepository;
    private final UserIdentityRepository userIdentityRepository;
    private final PasswordEncoder passwordEncoder;

    public GoogleAccountService(UserRepository userRepository,
                                UserIdentityRepository userIdentityRepository,
                                PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.userIdentityRepository = userIdentityRepository;
        this.passwordEncoder = passwordEncoder;
    }

    /** Yetkiler yalnızca yerel role'den gelir -- {@code CustomUserDetailsService} ile aynı biçim. */
    public static List<GrantedAuthority> authoritiesOf(User user) {
        return List.of(new SimpleGrantedAuthority("ROLE_" + user.getRole().name()));
    }

    /**
     * Google'la giriş/bağlama yalnızca ADMIN OLMAYAN hesaplar için. Rol her seferinde DB'deki
     * güncel satırdan okunur: sonradan ADMIN yapılan bir hesabın eski bağlantısı da işe yaramaz.
     */
    public static boolean allowsGoogleSignIn(User user) {
        return user.getRole() != Role.ADMIN;
    }

    @Transactional(readOnly = true)
    public Optional<User> findLinkedUser(String googleSubject) {
        return userIdentityRepository.findWithUser(IdentityProvider.GOOGLE, googleSubject)
                .map(UserIdentity::getUser);
    }

    @Transactional(readOnly = true)
    public boolean hasAccountWithEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    /**
     * E-postası eşleşen mevcut hesap Google'la kullanılamıyorsa ({@link #allowsGoogleSignIn})
     * true; böyle bir hesap yoksa false. Parola isteyen bağlama adımı ADMIN'e hiç açılmasın diye.
     */
    @Transactional(readOnly = true)
    public boolean isGoogleSignInBlockedForEmail(String email) {
        return userRepository.findByEmail(email)
                .filter(user -> !allowsGoogleSignIn(user))
                .isPresent();
    }

    /**
     * Koşulları kabul etmiş yeni bir Google kullanıcısı için şifresiz bir USER hesabı açar.
     * Bu Google hesabı bu arada (ör. başka bir sekmede) zaten bağlandıysa o hesabı döner.
     *
     * @throws DuplicateEmailException e-posta bu arada başka bir hesap tarafından alındıysa --
     *                                 çağıran taraf bağlama adımına geçmelidir
     * @throws AccessDeniedException   bu Google hesabı bir ADMIN hesabına bağlıysa
     */
    @Transactional
    public User createAccount(PendingGoogleSignIn pending) {
        Optional<User> alreadyLinked = findLinkedUser(pending.subject());
        if (alreadyLinked.isPresent()) {
            if (!allowsGoogleSignIn(alreadyLinked.get())) {
                throw new AccessDeniedException("Google sign-in is not allowed for this account");
            }
            return alreadyLinked.get();
        }
        if (userRepository.existsByEmail(pending.email())) {
            throw new DuplicateEmailException(pending.email());
        }

        LocalDateTime now = LocalDateTime.now();
        User user = userRepository.save(User.builder()
                .email(pending.email())
                .passwordHash(null)
                .displayName(displayNameOf(pending))
                .role(Role.USER)
                .createdAt(now)
                .updatedAt(now)
                .build());
        saveIdentity(user, pending.subject(), now);
        return user;
    }

    /**
     * Google kimliğini, e-postası eşleşen mevcut hesaba -- yalnızca o hesabın şifresi
     * doğruysa -- bağlar. Başarısız her sonuçta DB'de hiçbir şey değişmez. ADMIN hesabı
     * şifreye BAKILMADAN reddedilir: bu form yönetici şifresi için bir deneme yeri olmasın.
     */
    @Transactional
    public LinkOutcome link(PendingGoogleSignIn pending, String rawPassword) {
        Optional<User> target = userRepository.findByEmail(pending.email());
        if (target.isEmpty()) {
            return LinkOutcome.notLinkable();
        }
        User user = target.get();
        if (!allowsGoogleSignIn(user)) {
            return LinkOutcome.notLinkable();
        }

        Optional<User> alreadyLinked = findLinkedUser(pending.subject());
        if (alreadyLinked.isPresent()) {
            // Aynı bağlantı zaten var (ör. çift gönderim): yeniden şifre doğrulamaya gerek yok
            // ama başka bir hesaba bağlı bir Google hesabı ASLA buraya taşınmaz.
            return alreadyLinked.get().getId().equals(user.getId())
                    ? LinkOutcome.linked(user)
                    : LinkOutcome.notLinkable();
        }
        if (user.getPasswordHash() == null
                || userIdentityRepository.existsByUserAndProvider(user, IdentityProvider.GOOGLE)) {
            return LinkOutcome.notLinkable();
        }
        if (rawPassword == null || !passwordEncoder.matches(rawPassword, user.getPasswordHash())) {
            return LinkOutcome.wrongPassword();
        }

        saveIdentity(user, pending.subject(), LocalDateTime.now());
        return LinkOutcome.linked(user);
    }

    private void saveIdentity(User user, String subject, LocalDateTime now) {
        // saveAndFlush: eşzamanlı bir bağlantı UNIQUE kısıtına çarparsa hata bu metodun
        // transaction'ı içinde çıksın ve her şey geri alınsın.
        userIdentityRepository.saveAndFlush(UserIdentity.builder()
                .user(user)
                .provider(IdentityProvider.GOOGLE)
                .providerSubject(subject)
                .createdAt(now)
                .build());
    }

    private static String displayNameOf(PendingGoogleSignIn pending) {
        String name = pending.displayName() == null ? "" : pending.displayName().trim();
        if (name.isEmpty()) {
            name = pending.email().substring(0, pending.email().indexOf('@'));
        }
        return name.length() > MAX_DISPLAY_NAME_LENGTH ? name.substring(0, MAX_DISPLAY_NAME_LENGTH) : name;
    }

    public enum LinkResult { LINKED, WRONG_PASSWORD, NOT_LINKABLE }

    public record LinkOutcome(LinkResult result, User user) {

        static LinkOutcome linked(User user) {
            return new LinkOutcome(LinkResult.LINKED, user);
        }

        static LinkOutcome wrongPassword() {
            return new LinkOutcome(LinkResult.WRONG_PASSWORD, null);
        }

        static LinkOutcome notLinkable() {
            return new LinkOutcome(LinkResult.NOT_LINKABLE, null);
        }
    }
}
