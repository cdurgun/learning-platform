import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Id;

public class EnumeratedFieldExample {

    enum Difficulty {
        BEGINNER, INTERMEDIATE, ADVANCED
    }

    @Entity
    static class Topic {
        @Id
        private Long id;

        // EnumType.STRING stores the enum's NAME ("INTERMEDIATE") in the
        // column -- readable in the database, and safe to reorder the
        // enum's constants later without corrupting existing rows. This
        // is what this project's own Topic entity actually uses.
        @Enumerated(EnumType.STRING)
        @Column(nullable = false)
        private Difficulty difficulty;

        // The alternative, EnumType.ORDINAL (or omitting @Enumerated
        // entirely, which defaults to it), stores the enum's POSITION
        // (0, 1, 2, ...) instead. It looks harmless until someone inserts
        // a new constant in the middle of the enum later -- every existing
        // row's stored number now points at a DIFFERENT constant than the
        // one it was saved with, silently. Avoid ORDINAL in real code.
    }

    public static void main(String[] args) {
        Topic topic = new Topic();
        topic.difficulty = Difficulty.INTERMEDIATE;

        System.out.println(topic.difficulty); // stored as the string "INTERMEDIATE"
    }
}
