import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;

import java.util.ArrayList;
import java.util.List;

@Entity
class CategoryCascadeExample {
    @Id
    private Long id;

    // Without "cascade", saving a new Category does NOT automatically
    // save the Topics added to its list -- each would need its own
    // explicit topicRepository.save(...) call. CascadeType.PERSIST makes
    // categoryRepository.save(category) also save every Topic in
    // "topics", in the same operation.
    //
    // CascadeType.REMOVE makes deleting a Category also delete every
    // Topic that still belongs to it -- appropriate here, since a Topic
    // genuinely can't exist without a Category (category_id is
    // nullable = false on this project's real schema). CascadeType.MERGE
    // extends that same "do it for the children too" idea to updates.
    // CascadeType.ALL is shorthand for PERSIST + MERGE + REMOVE (and two
    // less common ones) together.
    @OneToMany(mappedBy = "category", fetch = FetchType.LAZY,
            cascade = CascadeType.ALL, orphanRemoval = true)
    private List<TopicCascadeExample> topics = new ArrayList<>();

    void addTopic(TopicCascadeExample topic) {
        topics.add(topic);
        topic.setCategory(this);
    }

    // orphanRemoval = true covers a DIFFERENT case than CascadeType.REMOVE:
    // removing a Topic from THIS LIST (topics.remove(someTopic)) -- without
    // deleting the Category itself at all -- deletes that Topic from the
    // database too, because it no longer belongs to anything. Without
    // orphanRemoval, that Topic would simply become an orphaned row,
    // still present but disconnected.
    void removeTopic(TopicCascadeExample topic) {
        topics.remove(topic);
    }
}

@Entity
class TopicCascadeExample {
    @Id
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    private CategoryCascadeExample category;

    void setCategory(CategoryCascadeExample category) {
        this.category = category;
    }
}
