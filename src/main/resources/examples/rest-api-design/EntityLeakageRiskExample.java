// Returning a JPA entity directly from a @RestController -- letting Jackson serialize
// it as-is -- looks convenient, but couples your HTTP contract to your database
// schema and can leak things you never meant to expose.
class EntityLeakageRiskExample {

    // A typical entity: exactly what the database needs, nothing about what an API
    // consumer should see.
    static class UserEntity {
        Long id;
        String email;
        String passwordHash;       // never meant to leave the server
        String internalNotes;      // an admin-only field, added later by someone else
        java.util.List<String> roles; // in a real @Entity, this would be a LAZY collection

        UserEntity(Long id, String email, String passwordHash, String internalNotes, java.util.List<String> roles) {
            this.id = id;
            this.email = email;
            this.passwordHash = passwordHash;
            this.internalNotes = internalNotes;
            this.roles = roles;
        }
    }

    // What Jackson would serialize if this entity were returned directly from a
    // @RestController method -- every field, by default, becomes a JSON property.
    static String naiveSerialize(UserEntity user) {
        return "{\"id\":" + user.id
                + ",\"email\":\"" + user.email + "\""
                + ",\"passwordHash\":\"" + user.passwordHash + "\""      // leaked
                + ",\"internalNotes\":\"" + user.internalNotes + "\""   // leaked
                + ",\"roles\":" + user.roles + "}";
    }

    public static void main(String[] args) {
        UserEntity user = new UserEntity(1L, "ada@example.com", "$2a$10$abcdef...",
                "flagged for review 2025-11-02", java.util.List.of("USER"));

        System.out.println(naiveSerialize(user));
        // {"id":1,"email":"ada@example.com","passwordHash":"$2a$10$abcdef...",
        //  "internalNotes":"flagged for review 2025-11-02","roles":[USER]}

        // Two separate problems bundled into one bad decision:
        // 1) passwordHash/internalNotes were never meant to be public API fields.
        // 2) In a REAL @Entity, "roles" would likely be a LAZY collection -- serializing
        //    it outside an open Hibernate session throws LazyInitializationException,
        //    which is exactly why this project's TopicController resolves associations
        //    with an explicit join fetch (see TopicRepository.findBySlugWithCategoryAndCourse)
        //    instead of leaving them to be touched later, e.g. during serialization.
    }
}
