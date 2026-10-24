package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Role;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.repository.UserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Locale;

/**
 * Yeni kullanıcı kaydı — email/password/display name doğrulaması
 * {@code RegisterForm}'daki jakarta.validation anotasyonlarında, burada yalnızca
 * "email zaten var mı" ve şifre encode etme var. Rol her zaman {@link Role#USER} —
 * kayıt formu üzerinden rol seçilemiyor (bilinçli, güvenlik gereği).
 */
@Service
public class UserRegistrationService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public UserRegistrationService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Transactional
    public User register(String email, String rawPassword, String displayName) {
        String normalizedEmail = normalizeEmail(email);

        if (userRepository.existsByEmail(normalizedEmail)) {
            throw new DuplicateEmailException(normalizedEmail);
        }

        LocalDateTime now = LocalDateTime.now();
        User user = User.builder()
                .email(normalizedEmail)
                .passwordHash(passwordEncoder.encode(rawPassword))
                .displayName(displayName.trim())
                .role(Role.USER)
                .createdAt(now)
                .updatedAt(now)
                .build();

        return userRepository.save(user);
    }

    /**
     * Kayıtta ve Google eşleştirmesinde AYNI e-posta biçimi. {@code Locale.ROOT}:
     * JVM Türkçe çalışırsa düz {@code toLowerCase()} "I"yı noktasız "ı" yapar ve Google'ın
     * gönderdiği adresle eşleşmez (bkz. GoogleOidcUserService).
     */
    public static String normalizeEmail(String email) {
        return email.trim().toLowerCase(Locale.ROOT);
    }
}
