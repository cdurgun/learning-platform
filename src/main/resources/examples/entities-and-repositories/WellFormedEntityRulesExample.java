import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

import java.util.Objects;

@Entity
public class WellFormedEntityRulesExample {

    @Id
    @GeneratedValue
    private Long id;

    private String slug;

    // A no-args constructor is REQUIRED -- Hibernate creates entity
    // instances via reflection, before any field is populated, so there
    // must be a constructor it can call with nothing. "protected" (rather
    // than "public") is a common convention: it keeps the constructor
    // available to Hibernate and to code in the same package, while
    // discouraging application code elsewhere from calling it directly
    // and getting a half-built entity.
    protected WellFormedEntityRulesExample() {
    }

    public WellFormedEntityRulesExample(String slug) {
        this.slug = slug;
    }

    // equals()/hashCode() based on the ID is the common, safe choice for
    // an entity -- but only once the entity actually HAS an id. Two
    // brand-new, unsaved instances both have id == null, so comparing by
    // id alone would make every new, unsaved entity "equal" to every
    // other one -- this implementation deliberately treats two entities
    // as equal ONLY when they both have a real, matching id.
    @Override
    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof WellFormedEntityRulesExample that)) {
            return false;
        }
        return id != null && id.equals(that.id);
    }

    @Override
    public int hashCode() {
        // A FIXED value, not Objects.hash(id) -- an entity's hashCode
        // must never change after it's been placed in a HashSet/HashMap,
        // but its id DOES change (from null to a real value) the moment
        // it's saved. Using a constant keeps hashCode stable across that
        // transition; equals() above still does the real comparison work.
        return Objects.hashCode(getClass());
    }
}
