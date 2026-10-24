package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Role;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Locale;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class UserRegistrationServiceTest {

    @Mock
    private UserRepository userRepository;
    @Mock
    private PasswordEncoder passwordEncoder;

    private UserRegistrationService newService() {
        return new UserRegistrationService(userRepository, passwordEncoder);
    }

    @Test
    void registersNewUserWithEncodedPasswordAndUserRole() {
        when(userRepository.existsByEmail("new@example.com")).thenReturn(false);
        when(passwordEncoder.encode("plain-password")).thenReturn("bcrypt-hash");
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> invocation.getArgument(0));

        User saved = newService().register("New@Example.com", "plain-password", "New User");

        ArgumentCaptor<User> captor = ArgumentCaptor.forClass(User.class);
        verify(userRepository).save(captor.capture());
        User persisted = captor.getValue();

        assertThat(persisted.getEmail()).isEqualTo("new@example.com");
        assertThat(persisted.getPasswordHash()).isEqualTo("bcrypt-hash");
        assertThat(persisted.getDisplayName()).isEqualTo("New User");
        assertThat(persisted.getRole()).isEqualTo(Role.USER);
        assertThat(persisted.getCreatedAt()).isNotNull();
        assertThat(persisted.getUpdatedAt()).isNotNull();
        assertThat(saved).isSameAs(persisted);
    }

    @Test
    void normalizesEmailTheSameWayUnderATurkishDefaultLocale() {
        // Türkçe locale'de "I".toLowerCase() noktasız "ı" olur; Google'dan gelen "ilker@..."
        // ile eşleşmezdi (bkz. GoogleAccountService -- iki akış aynı normalizasyonu kullanır).
        Locale original = Locale.getDefault();
        Locale.setDefault(Locale.forLanguageTag("tr-TR"));
        try {
            when(userRepository.save(any(User.class))).thenAnswer(invocation -> invocation.getArgument(0));

            User saved = newService().register(" ILKER@EXAMPLE.COM ", "plain-password", "Ilker");

            assertThat(saved.getEmail()).isEqualTo("ilker@example.com");
            verify(userRepository).existsByEmail("ilker@example.com");
            assertThat(UserRegistrationService.normalizeEmail("ILKER@EXAMPLE.COM")).isEqualTo("ilker@example.com");
        } finally {
            Locale.setDefault(original);
        }
    }

    @Test
    void rejectsDuplicateEmailWithoutHashingPasswordOrSaving() {
        when(userRepository.existsByEmail("taken@example.com")).thenReturn(true);

        assertThatThrownBy(() -> newService().register("taken@example.com", "whatever", "Someone"))
                .isInstanceOf(DuplicateEmailException.class);

        verifyNoInteractions(passwordEncoder);
        verify(userRepository, never()).save(any(User.class));
    }
}
