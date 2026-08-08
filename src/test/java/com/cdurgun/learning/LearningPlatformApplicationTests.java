package com.cdurgun.learning;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

/**
 * En temel "uygulama context'i patlamadan ayağa kalkıyor mu?" testi.
 * `test` profilinin PostgreSQL'e erişebilmesi gerekir (bkz. application-test.yml).
 */
@SpringBootTest
@ActiveProfiles("test")
class LearningPlatformApplicationTests {

    @Test
    void contextLoads() {
    }
}
