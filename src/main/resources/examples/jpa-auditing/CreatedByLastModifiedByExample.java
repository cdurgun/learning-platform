import jakarta.persistence.Entity;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.Id;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.domain.AuditorAware;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Optional;

// @CreatedBy/@LastModifiedBy work exactly like @CreatedDate/@LastModifiedDate
// -- same listener, same lifecycle timing -- but capture WHO made the
// change instead of WHEN. This project's real Question entity already has
// a "reviewedBy" column (set manually, by an admin doing a DB UPDATE, per
// this project's own review workflow) -- @CreatedBy/@LastModifiedBy solve
// a related but different problem: recording who created/last touched the
// row itself, automatically, not a separate manual review action.
@Entity
@EntityListeners(AuditingEntityListener.class)
class AuditedByQuestionExample {

    @Id
    private Long id;

    @CreatedBy
    private String createdBy;

    @LastModifiedBy
    private String lastModifiedBy;
}

// AuditorAware<T> is where "who" actually comes from -- Spring Data JPA
// has no idea who the current user is on its own; this bean is what
// supplies that answer, called automatically every time an audited entity
// is saved.
@Configuration
class AuditorAwareConfig {

    @Bean
    AuditorAware<String> auditorProvider() {
        // A real application would read this from Spring Security's
        // SecurityContextHolder (the currently authenticated user's name);
        // returning a fixed value here keeps the example focused on
        // AuditorAware's role, not on Spring Security itself.
        return () -> Optional.of("system");
    }
}
