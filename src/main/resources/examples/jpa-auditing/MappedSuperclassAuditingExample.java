import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.Id;
import jakarta.persistence.MappedSuperclass;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

// @MappedSuperclass isn't itself an @Entity -- it's a base class whose
// fields get copied into every entity that extends it, without a table of
// its own. This is where the audit fields belong once more than one
// entity needs them: this project's real Question already has createdAt/
// updatedAt columns (set by hand today, in QuestionIngestService) -- if
// QuestionOption or another entity needed the same two columns, repeating
// @CreatedDate/@LastModifiedDate on each one would itself become the same
// kind of repetition auditing was meant to remove in the first place.
@MappedSuperclass
@EntityListeners(AuditingEntityListener.class)
abstract class AuditableBaseExample {

    @CreatedDate
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @LastModifiedDate
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}

// Any entity extending AuditableBaseExample gets createdAt/updatedAt for
// free -- no @EntityListeners of its own needed (it's inherited), and no
// repeated field declarations either.
@Entity
class AuditableQuestionExample extends AuditableBaseExample {
    @Id
    private Long id;
    private String text;
}
