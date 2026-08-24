import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

// @EntityListeners alone isn't quite enough -- @EnableJpaAuditing, on a
// @Configuration class, is what turns Spring Data JPA's auditing
// infrastructure on for the application as a whole. Without it,
// @CreatedDate/@LastModifiedDate fields are simply never populated --
// silently left null, with no error to point at the missing piece.
@Configuration
@EnableJpaAuditing
class JpaAuditingConfig {
}

// With both pieces in place -- @EntityListeners on the entity, and
// @EnableJpaAuditing on a configuration class -- saving an
// AuditedQuestionExample no longer needs anything like
// ManualTimestampProblemExample's "LocalDateTime.now()" line anywhere:
//
//   AuditedQuestionExample q = new AuditedQuestionExample();
//   repository.save(q); // createdAt AND updatedAt are populated automatically
