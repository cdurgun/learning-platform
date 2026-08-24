import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;

import java.util.HashSet;
import java.util.Set;

// A plausible new relationship this project doesn't currently have: a
// Topic can carry several Tags, and a Tag can label several Topics --
// neither side "owns" the other the way a foreign key does in
// @ManyToOne, so the relationship needs its own JOIN TABLE.
@Entity
class TopicWithTagsExample {
    @Id
    private Long id;

    // @JoinTable describes that separate table explicitly -- "topic_tag",
    // with a topic_id column and a tag_id column, neither of which lives
    // on "topic" or "tag" themselves.
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "topic_tag",
            joinColumns = @JoinColumn(name = "topic_id"),
            inverseJoinColumns = @JoinColumn(name = "tag_id"))
    private Set<TagExample> tags = new HashSet<>();

    Set<TagExample> getTags() {
        return tags;
    }
}

@Entity
class TagExample {
    @Id
    private Long id;
    private String name;
}

// This project's REAL QuizQuestion is a different, often better, pattern
// for the same underlying idea (Quiz and Question relate to many of each
// other): instead of a raw @ManyToMany, it's a full ENTITY of its own,
// with its own "position" column -- a plain @ManyToMany join table has no
// room for extra data ABOUT the relationship itself, only the link.
// Reach for an explicit join entity, as this project already does,
// whenever the relationship needs to carry data beyond just "these two
// are linked."
