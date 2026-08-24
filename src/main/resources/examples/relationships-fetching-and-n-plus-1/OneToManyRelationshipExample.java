import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;

import java.util.ArrayList;
import java.util.List;

// This project's real Topic already has @ManyToOne(fetch = LAZY) Category
// -- covered in "Entities and the Repository Abstraction" and in
// "Transaction Management"'s LazyInitializationException section. What's
// new here is the OTHER side of that same relationship: Category "has
// many" Topics.
@Entity
class CategoryWithTopicsExample {
    @Id
    private Long id;

    // mappedBy = "category" points at the FIELD on TopicExample that owns
    // this relationship -- @OneToMany is the "many" side's mirror image,
    // not a second, independent mapping. The foreign key (category_id)
    // still lives on the topic table, exactly as it already does in this
    // project's real schema; @OneToMany adds no column of its own.
    @OneToMany(mappedBy = "category", fetch = FetchType.LAZY)
    private List<TopicExample> topics = new ArrayList<>();

    List<TopicExample> getTopics() {
        return topics;
    }
}

@Entity
class TopicExample {
    @Id
    private Long id;

    // This is the OWNING side -- the side with the actual foreign-key
    // column. This project's real Topic entity has exactly this field.
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    private CategoryWithTopicsExample category;
}
