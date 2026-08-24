import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import org.hibernate.annotations.BatchSize;

import java.util.List;

// A DIFFERENT fix for the same N+1 problem -- useful specifically when
// @EntityGraph isn't a good fit (for instance, when many different
// queries touch this relationship, and adding @EntityGraph to every one
// of them would be repetitive).
@Entity
class CategoryBatchFetchExample {
    @Id
    private Long id;

    // @BatchSize(size = 20) doesn't eliminate the extra queries the way
    // @EntityGraph does -- it groups them. Instead of one query PER
    // category (the 1+N shape), Hibernate fetches topics for up to 20
    // categories' worth of ids AT ONCE, in a single "WHERE category_id IN
    // (?, ?, ..., up to 20 values)" query.
    @OneToMany(mappedBy = "category", fetch = FetchType.LAZY)
    @BatchSize(size = 20)
    private List<TopicBatchFetchExample> topics;
}

@Entity
class TopicBatchFetchExample {
    @Id
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id")
    private CategoryBatchFetchExample category;
}

// With 7 categories and batch size 20 (larger than the category count),
// NPlusOneProblemExample's 1+7 queries become just 1+1: one query for the
// categories, and ONE batched query -- "WHERE category_id IN (1,2,3,4,5,6,7)"
// -- covering every category's topics at once, instead of seven separate
// single-category queries.
