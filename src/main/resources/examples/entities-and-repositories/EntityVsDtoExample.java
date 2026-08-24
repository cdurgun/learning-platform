import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@Entity
class Topic {
    @Id
    @GeneratedValue
    private Long id;
    private String slug;
    private Integer estimatedMinutes;
    // A real entity also carries a lazy @ManyToOne Category, JPA-internal
    // proxy state, and more -- none of which a client asking for "a topic"
    // over HTTP should ever see or need to know about.

    Long getId() { return id; }
    String getSlug() { return slug; }
    Integer getEstimatedMinutes() { return estimatedMinutes; }
}

// A DTO -- as covered in "Record" -- is a SEPARATE, deliberately narrow
// type exposing only what a specific API response actually needs.
record TopicResponse(Long id, String slug, Integer estimatedMinutes) {
    static TopicResponse from(Topic topic) {
        return new TopicResponse(topic.getId(), topic.getSlug(), topic.getEstimatedMinutes());
    }
}

// Returning the @Entity directly from a controller couples the API's
// public shape to the database mapping (renaming a column would silently
// change the JSON response) and risks serializing a lazy field that
// throws outside a transaction -- covered in "Transaction Management."
// Returning a DTO avoids both: the response shape is controlled
// explicitly, independent of how the entity is mapped or fetched.
@RestController
class TopicController {

    @GetMapping("/topics/{id}")
    public TopicResponse getTopic(@PathVariable Long id) {
        Topic topic = new Topic(); // a real controller would load this from a repository
        return TopicResponse.from(topic);
    }
}
