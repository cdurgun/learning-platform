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
    void throwsWhenEmailNotFound() {
        when(userRepository.findByEmail("missing@example.com")).thenReturn(Optional.empty());

        assertThatThrownBy(() -> newService().loadUserByUsername("missing@example.com"))
                .isInstanceOf(UsernameNotFoundException.class);
    }
}
