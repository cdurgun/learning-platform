import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

// The SAME class as PlainJavaTopicExample's Topic, with three annotations
// added. Nothing about the class's own Java behavior changed -- these
// annotations are metadata, read by JPA's implementation (Hibernate) to
// generate the INSERT/UPDATE/SELECT SQL that PlainJavaTopicExample had to
// write by hand.
@Entity
public class MinimalEntityExample {

    @Id
    @GeneratedValue
    private Long id;

    private String title;

    // A no-argument constructor is required -- JPA implementations create
    // entity instances via reflection before populating their fields. The
    // full reasoning behind this (and everything else about mapping an
    // entity correctly) is covered in "Entities and the Repository
    // Abstraction," the next lesson in this series.
    protected MinimalEntityExample() {
    }

    public MinimalEntityExample(String title) {
        this.title = title;
    }
}
