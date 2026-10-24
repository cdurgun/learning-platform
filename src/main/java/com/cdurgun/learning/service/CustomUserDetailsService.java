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
        // Kayıtla aynı biçim: kayıtta küçük harfe çevrilen adres girişte de aynı kuralla aranır.
        User user = userRepository.findByEmail(UserRegistrationService.normalizeEmail(email))
                .orElseThrow(() -> new UsernameNotFoundException("Kullanıcı bulunamadı: " + email));

        // Yalnızca Google ile açılmış (şifresiz) hesap: şifre formu üzerinden giriş yok.
        // "Kullanıcı yok" ile aynı yoldan geçer, yani dışarıya aynı "geçersiz e-posta veya
        // şifre" hatası olarak görünür -- hesabın var olup olmadığını sızdırmaz.
        if (user.getPasswordHash() == null) {
            throw new UsernameNotFoundException("Şifresiz hesap: " + email);
        }

        return org.springframework.security.core.userdetails.User
                .withUsername(user.getEmail())
                .password(user.getPasswordHash())
                .authorities("ROLE_" + user.getRole().name())
                .build();
    }
}
