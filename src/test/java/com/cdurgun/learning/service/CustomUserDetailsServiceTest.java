package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Role;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import java.time.LocalDateTime;
import java.util.Locale;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CustomUserDetailsServiceTest {

    @Mock
    private UserRepository userRepository;

    private CustomUserDetailsService newService() {
        return new CustomUserDetailsService(userRepository);
    }

    @Test
    void loadsUserByEmailWithRoleAuthority() {
        User user = User.builder()
                .id(1L)
                .email("someone@example.com")
                .passwordHash("bcrypt-hash")
                .displayName("Someone")
                .role(Role.USER)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();
        when(userRepository.findByEmail("someone@example.com")).thenReturn(Optional.of(user));

        UserDetails userDetails = newService().loadUserByUsername("someone@example.com");

        assertThat(userDetails.getUsername()).isEqualTo("someone@example.com");
        assertThat(userDetails.getPassword()).isEqualTo("bcrypt-hash");
        assertThat(userDetails.getAuthorities())
                .extracting(Object::toString)
                .containsExactly("ROLE_USER");
    }

    @Test
    void looksUpTheNormalizedEmail() {
        when(userRepository.findByEmail("someone@example.com")).thenReturn(Optional.of(user("someone@example.com")));

        UserDetails userDetails = newService().loadUserByUsername("  SomeOne@Example.COM ");

        assertThat(userDetails.getUsername()).isEqualTo("someone@example.com");
    }

    @Test
    void uppercaseIIsLoweredWithTheRootLocaleUnderTurkishDefault() {
        when(userRepository.findByEmail("ilker@example.com")).thenReturn(Optional.of(user("ilker@example.com")));
        Locale original = Locale.getDefault();
        Locale.setDefault(Locale.forLanguageTag("tr-TR"));
        try {
            // tr-TR'de düz toLowerCase() "I"yı noktasız "ı" yapardı: "ılker@example.com".
            assertThat(newService().loadUserByUsername("ILKER@EXAMPLE.COM").getUsername())
                    .isEqualTo("ilker@example.com");
        } finally {
            Locale.setDefault(original);
        }
    }

    @Test
    void throwsWhenEmailNotFound() {
        when(userRepository.findByEmail("missing@example.com")).thenReturn(Optional.empty());

        assertThatThrownBy(() -> newService().loadUserByUsername("missing@example.com"))
                .isInstanceOf(UsernameNotFoundException.class);
    }

    private static User user(String email) {
        return User.builder()
                .id(2L)
                .email(email)
                .passwordHash("bcrypt-hash")
                .displayName("User")
                .role(Role.USER)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();
    }
}
