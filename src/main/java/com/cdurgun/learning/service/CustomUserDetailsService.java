package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.repository.UserRepository;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

/**
 * Spring Security'nin {@code DaoAuthenticationProvider}'ının kullandığı köprü —
 * email'i {@link User}'a, {@link User}'ı Spring Security'nin kendi
 * {@link org.springframework.security.core.userdetails.User} temsiline çevirir.
 * Ayrı bir {@code UserPrincipal} sınıfı bilerek yazılmadı: v1'de authority
 * dışında (roller) principal'dan başka hiçbir alana ihtiyaç yok.
 */
@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final UserRepository userRepository;

    public CustomUserDetailsService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new UsernameNotFoundException("Kullanıcı bulunamadı: " + email));

        return org.springframework.security.core.userdetails.User
                .withUsername(user.getEmail())
                .password(user.getPasswordHash())
                .authorities("ROLE_" + user.getRole().name())
                .build();
    }
}
