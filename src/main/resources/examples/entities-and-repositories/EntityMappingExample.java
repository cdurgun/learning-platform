import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

// A fuller, teaching-annotated look at THIS PROJECT'S OWN Topic entity
// (see src/main/java/com/cdurgun/learning/domain/Topic.java) -- every
// annotation here maps directly onto a real column in the real "topic"
// table.
@Entity
// @Table names the table explicitly. Without it, Hibernate would derive a
// name from the class name itself -- being explicit avoids surprises when
// the class name and the table name diverge, or just for clarity.
@Table(name = "topic")
public class EntityMappingExample {

    @Id
    // GenerationType.IDENTITY delegates id generation to the database
    // itself (PostgreSQL's own auto-increment) -- the simplest strategy,
    // and the one this project uses everywhere. SEQUENCE and AUTO exist
    // for databases/scenarios that need more control over how ids are
    // generated; IDENTITY is enough for the vast majority of applications.
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // nullable = false, unique = true directly becomes a NOT NULL UNIQUE
    // constraint on the "slug" column -- these constraints are enforced by
    // the DATABASE, not just checked in Java, exactly like the Flyway
    // migration that created this table declares them.
    @Column(nullable = false, unique = true)
    private String slug;

    // A field with no @Column at all is still mapped -- Hibernate derives
    // a column name from the field name (estimatedMinutes -> a column
    // matching that name) unless told otherwise. @Column(name = "...") is
    // only needed when the column's real name doesn't match the field.
    @Column(name = "estimated_minutes")
    private Integer estimatedMinutes;

    // A relationship field -- @ManyToOne(fetch = FetchType.LAZY) tells
    // Hibernate that many Topics point to one Category. Treat this as just
    // another mapped field for now; exactly what "fetch = LAZY" means and
    // how relationships like this actually behave is the subject of
    // "Relationships, Fetching, and the N+1 Problem," later in this
    // category.
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "category_id", nullable = false)
    private CategoryStandIn category;

    protected EntityMappingExample() {
    }

    static class CategoryStandIn {
    }
}
