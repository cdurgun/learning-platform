package com.cdurgun.learning.config;

import com.cdurgun.learning.domain.Role;
import com.cdurgun.learning.domain.User;
import com.cdurgun.learning.repository.UserRepository;
import jakarta.servlet.http.HttpSession;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.mock.web.MockHttpSession;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Faz A/B (Question Review'in yetkilendirme kuralı + liste ekranı) doğrulaması.
 * Faz B'den itibaren {@code /{lang:en|tr}/admin/questions} gerçek bir sayfa --
 * ADMIN için artık 200 bekleniyor (Faz A'da, controller henüz yokken, "güvenlik
 * katmanını geçti" kanıtı 404 idi; controller eklenince bu doğal olarak 200'e
 * döndü). USER/anonim için katmanın kendisi hâlâ reddetmeli. ADMIN test
 * kullanıcısı, gerçek `/register` akışını (her zaman `role=USER` zorluyor)
 * BİLİNÇLİ OLARAK atlayıp doğrudan {@link UserRepository} ile ekleniyor -- bu,
 * üretim kayıt akışına dokunmadan test fixture'ı kurmanın standart yolu.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class AdminAuthorizationTest {

    @Autowired
    private MockMvc mockMvc;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private PasswordEncoder passwordEncoder;

    private String registerAndLoginAs(String password, Role role) throws Exception {
        String email = "admin-auth-" + UUID.randomUUID() + "@example.com";
        User user = User.builder()
                .email(email)
                .passwordHash(passwordEncoder.encode(password))
                .displayName("Test " + role)
                .role(role)
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();
        userRepository.save(user);
        return email;
    }

    private MockHttpSession loginSession(String email, String password) throws Exception {
        MvcResult result = mockMvc.perform(post("/en/login")
                        .param("username", email)
                        .param("password", password)
                        .with(csrf()))
                .andExpect(status().is3xxRedirection())
                .andReturn();
        HttpSession session = result.getRequest().getSession(false);
        return (MockHttpSession) session;
    }

    @Test
    void adminCanAccessAdminRouteInBothLanguages() throws Exception {
        String email = registerAndLoginAs("correct-password", Role.ADMIN);
        MockHttpSession session = loginSession(email, "correct-password");

        mockMvc.perform(get("/en/admin/questions").session(session))
                .andExpect(status().isOk());
        mockMvc.perform(get("/tr/admin/questions").session(session))
                .andExpect(status().isOk());
    }

    @Test
    void normalUserCannotAccessAdminRoutes() throws Exception {
        String email = registerAndLoginAs("correct-password", Role.USER);
        MockHttpSession session = loginSession(email, "correct-password");

        mockMvc.perform(get("/en/admin/questions").session(session))
                .andExpect(status().isForbidden());
        mockMvc.perform(get("/tr/admin/questions").session(session))
                .andExpect(status().isForbidden());
    }

    @Test
    void anonymousUserCannotAccessAdminRoutes() throws Exception {
        mockMvc.perform(get("/en/admin/questions"))
                .andExpect(status().is3xxRedirection());
        mockMvc.perform(get("/tr/admin/questions"))
                .andExpect(status().is3xxRedirection());
    }

    @Test
    void existingPublicRoutesRemainAccessibleAfterAdminRuleAdded() throws Exception {
        mockMvc.perform(get("/en")).andExpect(status().isOk());
        mockMvc.perform(get("/en/quiz")).andExpect(status().isOk());
        mockMvc.perform(get("/en/topics/enum")).andExpect(status().isOk());
    }
}
