import jakarta.persistence.Entity;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.Id;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

// @EntityListeners(AuditingEntityListener.class) is what actually makes
// @CreatedDate/@LastModifiedDate below do anything -- it registers a
// listener that runs automatically on this entity's own lifecycle events
// (right before the first INSERT, and right before every UPDATE), instead
// of any application code needing to set these fields itself.
@Entity
@EntityListeners(AuditingEntityListener.class)
class AuditedQuestionExample {

    @Id
    private Long id;

    private String text;

    // Populated automatically, exactly once, the moment this entity is
    // first persisted -- never touched again on later updates.
    @CreatedDate
    private LocalDateTime createdAt;

    // Populated automatically on the INITIAL insert, and then re-populated
    // on every single update after that -- this is the field
    // ManualTimestampProblemExample had to remember to update by hand,
    // every time, in every place.
    @LastModifiedDate
    private LocalDateTime updatedAt;
}
