package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.IdentityProvider;
import com.cdurgun.learning.domain.Role;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.repository.UserIdentityRepository;
import com.cdurgun.learning.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.test.context.ActiveProfiles;

import java.time.Instant;
import java.util.Locale;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/**
 * Hesap açma ve bağlama kuralları, gerçek şema (V1148'in UNIQUE kısıtları dahil) üzerinde.
 * Her test kendi rastgele e-postasını ve Google {@code sub}'ını üretir.
 */
@SpringBootTest
@ActiveProfiles("test")
class GoogleAccountServiceTest {

    @Autowired
    private GoogleAccountService googleAccountService;
    @Autowired
    private UserRegistrationService userRegistrationService;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private UserIdentityRepository userIdentityRepository;

    private static String randomEmail() {
        return "google-" + UUID.randomUUID() + "@example.com";
    }

    private static PendingGoogleSignIn pending(String email) {
        return PendingGoogleSignIn.of("sub-" + UUID.randomUUID(), email, "Google Name", Instant.now());
    }

    private boolean isLinked(String subject) {
        return userIdentityRepository.existsByProviderAndProviderSubject(IdentityProvider.GOOGLE, subject);
    }

    @Test
    void createsPasswordlessUserAccountLinkedToGoogleSubject() {
        PendingGoogleSignIn pending = pending(randomEmail());

        User user = googleAccountService.createAccount(pending);

        User stored = userRepository.findByEmail(pending.email()).orElseThrow();
        assertThat(stored.getId()).isEqualTo(user.getId());
        assertThat(stored.getPasswordHash()).isNull();
        assertThat(stored.getRole()).isEqualTo(Role.USER);
        assertThat(stored.getDisplayName()).isEqualTo("Google Name");
        assertThat(googleAccountService.findLinkedUser(pending.subject())).map(User::getId).contains(user.getId());
    }

    @Test
    void missingGoogleNameFallsBackToEmailLocalPart() {
        String email = randomEmail();
        PendingGoogleSignIn pending = PendingGoogleSignIn.of("sub-" + UUID.randomUUID(), email, null, Instant.now());

        User user = googleAccountService.createAccount(pending);

        assertThat(user.getDisplayName()).isEqualTo(email.substring(0, email.indexOf('@')));
    }

    @Test
    void neverCreatesAccountForAnAlreadyRegisteredEmail() {
        String email = randomEmail();
        userRegistrationService.register(email, "correct-password", "Existing");
        PendingGoogleSignIn pending = pending(email);

        assertThatThrownBy(() -> googleAccountService.createAccount(pending))
                .isInstanceOf(DuplicateEmailException.class);
        assertThat(isLinked(pending.subject())).isFalse();
    }

    @Test
    void creatingTwiceForTheSameGoogleAccountReturnsTheSameUser() {
        PendingGoogleSignIn pending = pending(randomEmail());

        User first = googleAccountService.createAccount(pending);
        User second = googleAccountService.createAccount(pending);

        assertThat(second.getId()).isEqualTo(first.getId());
    }

    @Test
    void wrongPasswordLeavesBothAccountsUnchanged() {
        String email = randomEmail();
        userRegistrationService.register(email, "correct-password", "Existing");
        PendingGoogleSignIn pending = pending(email);

        GoogleAccountService.LinkOutcome outcome = googleAccountService.link(pending, "wrong-password");

        assertThat(outcome.result()).isEqualTo(GoogleAccountService.LinkResult.WRONG_PASSWORD);
        assertThat(isLinked(pending.subject())).isFalse();
    }

    @Test
    void missingPasswordIsAWrongPassword() {
        String email = randomEmail();
        userRegistrationService.register(email, "correct-password", "Existing");
        PendingGoogleSignIn pending = pending(email);

        assertThat(googleAccountService.link(pending, null).result())
                .isEqualTo(GoogleAccountService.LinkResult.WRONG_PASSWORD);
        assertThat(isLinked(pending.subject())).isFalse();
    }

    @Test
    void correctPasswordLinksAndKeepsTheLocalRole() {
        String email = randomEmail();
        User existing = userRegistrationService.register(email, "correct-password", "Existing");
        PendingGoogleSignIn pending = pending(email);

        GoogleAccountService.LinkOutcome outcome = googleAccountService.link(pending, "correct-password");

        assertThat(outcome.result()).isEqualTo(GoogleAccountService.LinkResult.LINKED);
        assertThat(outcome.user().getId()).isEqualTo(existing.getId());
        User linked = googleAccountService.findLinkedUser(pending.subject()).orElseThrow();
        assertThat(linked.getRole()).isEqualTo(Role.USER);
        assertThat(linked.getPasswordHash()).isEqualTo(existing.getPasswordHash());
    }

    @Test
    void adminAccountIsNeverLinkedEvenWithTheCorrectPassword() {
        String email = randomEmail();
        User existing = userRegistrationService.register(email, "correct-password", "Admin");
        existing.setRole(Role.ADMIN);
        userRepository.save(existing);
        PendingGoogleSignIn pending = pending(email);

        assertThat(googleAccountService.link(pending, "correct-password").result())
                .isEqualTo(GoogleAccountService.LinkResult.NOT_LINKABLE);
        // Şifreye bakılmadan reddedilir: yanlış şifre de "yanlış şifre" değil, aynı sonuç.
        assertThat(googleAccountService.link(pending, "wrong-password").result())
                .isEqualTo(GoogleAccountService.LinkResult.NOT_LINKABLE);

        assertThat(isLinked(pending.subject())).isFalse();
        User stored = userRepository.findByEmail(email).orElseThrow();
        assertThat(stored.getRole()).isEqualTo(Role.ADMIN);
        assertThat(stored.getPasswordHash()).isEqualTo(existing.getPasswordHash());
    }

    @Test
    void existingGoogleLinkOfAnAccountLaterMadeAdminIsNoLongerUsable() {
        String email = randomEmail();
        userRegistrationService.register(email, "correct-password", "Promoted");
        PendingGoogleSignIn pending = pending(email);
        assertThat(googleAccountService.link(pending, "correct-password").result())
                .isEqualTo(GoogleAccountService.LinkResult.LINKED);
        User promoted = userRepository.findByEmail(email).orElseThrow();
        promoted.setRole(Role.ADMIN);
        userRepository.save(promoted);

        // Bağlantı satırı yerinde kalır ama ne "zaten bağlı" kısa yolu ne de bağlama onu kullandırır.
        assertThatThrownBy(() -> googleAccountService.createAccount(pending))
                .isInstanceOf(AccessDeniedException.class);
        assertThat(googleAccountService.link(pending, "correct-password").result())
                .isEqualTo(GoogleAccountService.LinkResult.NOT_LINKABLE);
        assertThat(userRepository.findAll().stream().filter(u -> u.getEmail().equals(email))).hasSize(1);
    }

    @Test
    void accountRegisteredUnderTurkishLocaleIsMatchedByItsGoogleEmail() {
        String localPart = "ilker-" + UUID.randomUUID();
        Locale original = Locale.getDefault();
        Locale.setDefault(Locale.forLanguageTag("tr-TR"));
        try {
            userRegistrationService.register(localPart.toUpperCase(Locale.ROOT) + "@EXAMPLE.COM",
                    "correct-password", "Ilker");
        } finally {
            Locale.setDefault(original);
        }
        // Google e-postayı küçük harfle gönderir; yeni hesap açılmaz, şifreyle bağlanır.
        PendingGoogleSignIn pending = pending(localPart + "@example.com");

        assertThat(googleAccountService.hasAccountWithEmail(pending.email())).isTrue();
        assertThatThrownBy(() -> googleAccountService.createAccount(pending))
                .isInstanceOf(DuplicateEmailException.class);
        assertThat(googleAccountService.link(pending, "correct-password").result())
                .isEqualTo(GoogleAccountService.LinkResult.LINKED);
    }

    @Test
    void accountAlreadyLinkedToAnotherGoogleAccountCannotBeLinkedAgain() {
        String email = randomEmail();
        userRegistrationService.register(email, "correct-password", "Existing");
        assertThat(googleAccountService.link(pending(email), "correct-password").result())
                .isEqualTo(GoogleAccountService.LinkResult.LINKED);

        PendingGoogleSignIn secondGoogleAccount = pending(email);
        GoogleAccountService.LinkOutcome outcome = googleAccountService.link(secondGoogleAccount, "correct-password");

        assertThat(outcome.result()).isEqualTo(GoogleAccountService.LinkResult.NOT_LINKABLE);
        assertThat(isLinked(secondGoogleAccount.subject())).isFalse();
    }

    @Test
    void googleAccountLinkedElsewhereIsNeverMovedToAnotherUser() {
        PendingGoogleSignIn original = pending(randomEmail());
        User owner = googleAccountService.createAccount(original);

        String otherEmail = randomEmail();
        userRegistrationService.register(otherEmail, "correct-password", "Other");
        PendingGoogleSignIn sameSubjectOtherEmail =
                PendingGoogleSignIn.of(original.subject(), otherEmail, "x", Instant.now());

        assertThat(googleAccountService.link(sameSubjectOtherEmail, "correct-password").result())
                .isEqualTo(GoogleAccountService.LinkResult.NOT_LINKABLE);
        assertThat(googleAccountService.findLinkedUser(original.subject())).map(User::getId).contains(owner.getId());
    }

    @Test
    void passwordlessAccountCannotBeLinkedByPassword() {
        PendingGoogleSignIn first = pending(randomEmail());
        googleAccountService.createAccount(first);

        PendingGoogleSignIn other = pending(first.email());
        assertThat(googleAccountService.link(other, "anything").result())
                .isEqualTo(GoogleAccountService.LinkResult.NOT_LINKABLE);
    }
}
