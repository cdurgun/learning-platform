import org.junit.jupiter.api.Test;
import org.springframework.boot.test.autoconfigure.orm.jpa.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

// This project's OWN application-test.yml has a real comment (written all
// the way back when the test database was first set up) that says this
// out loud: today's tests point at a manually created "learning_test"
// database on a locally running Postgres -- workable, but it requires
// that manual setup step, and every test run shares that same database
// rather than a genuinely clean, disposable one. The comment's own words:
// "Testcontainers ile her test çalıştırmasında izole, tek kullanımlık bir
// Postgres container'ı ayağa kaldırmak çok daha sağlam olur."
//
// AutoConfigureTestDatabase.Replace.NONE turns off @DataJpaTest's OWN
// default behavior of swapping in an embedded, in-memory database --
// without it, @DataJpaTest would try to replace whatever DataSource is
// configured with an embedded one instead of using Testcontainers' real
// PostgreSQL.
@Testcontainers
@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class TestcontainersSketchExample {

    // A REAL, disposable PostgreSQL instance, started in a Docker
    // container just for this test class, and torn down afterward -- not
    // a manually created, long-lived database, and not an embedded
    // in-memory substitute that might not behave identically to real
    // PostgreSQL for every query.
    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16");

    @DynamicPropertySource
    static void configureDataSource(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.datasource.username", postgres::getUsername);
        registry.add("spring.datasource.password", postgres::getPassword);
    }

    @Test
    void placeholder() {
        // This is a SKETCH of the setup, not a full worked example -- the
        // point is what each piece is FOR, not a deep dive into
        // Testcontainers itself, which is its own, separate topic.
    }
}
