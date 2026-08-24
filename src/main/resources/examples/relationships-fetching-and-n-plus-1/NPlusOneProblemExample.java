import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

// This is the concrete shape of the N+1 problem -- a correct, perfectly
// legal piece of code that still runs far more queries than it looks like
// it should.
interface CategoryNPlusOneRepositoryExample extends JpaRepository<CategoryNPlusOneExample, Long> {
}

@Entity
class CategoryNPlusOneExample {
    @Id
    private Long id;

    @OneToMany(mappedBy = "category", fetch = FetchType.LAZY)
    private List<TopicNPlusOneExample> topics;

    List<TopicNPlusOneExample> getTopics() {
        return topics;
    }
}

@Entity
class TopicNPlusOneExample {
    @Id
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private CategoryNPlusOneExample category;
}

class NPlusOneProblemExample {

    static void printAllTopicCounts(CategoryNPlusOneRepositoryExample repository) {
        // Query #1: one SELECT fetching every Category -- say there are 7.
        List<CategoryNPlusOneExample> categories = repository.findAll();

        for (CategoryNPlusOneExample category : categories) {
            // category.getTopics() is LAZY -- accessing it here, inside the
            // loop, triggers a SEPARATE query, right now, for THIS one
            // category's topics alone.
            //
            // Query #2, #3, #4, #5, #6, #7, #8: one MORE SELECT, per
            // category, run one at a time as the loop reaches each one.
            System.out.println(category.getTopics().size());
        }
        // Total: 1 query to fetch the categories ("N" categories), PLUS
        // one query PER category to fetch its topics -- "N+1" queries for
        // what looks, at a glance, like a single loop over already-fetched
        // data. With 7 categories, that's 8 queries; with 100, it's 101.
    }
}
