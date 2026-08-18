// The DTO pattern only pays off once something actually converts between entity and
// DTO. The simplest version is a plain static method -- no mapping library needed
// for a shape this small (see this lesson's "Example Writing Principles" -- don't add
// infrastructure a small example doesn't need).
class EntityToDtoMappingExample {

    record TopicSummary(String slug, String title, String difficulty) {
    }

    // Stands in for this project's real Topic/TopicTranslation entities -- a
    // simplified shape, just enough to show the mapping.
    record TopicEntityStub(String slug, String difficulty, String translatedTitle) {
    }

    static TopicSummary toDto(TopicEntityStub entity) {
        return new TopicSummary(entity.slug(), entity.translatedTitle(), entity.difficulty());
    }

    public static void main(String[] args) {
        TopicEntityStub entity = new TopicEntityStub("advanced-spring-mvc", "ADVANCED", "Advanced Spring MVC");

        TopicSummary dto = toDto(entity);
        System.out.println(dto);
        // TopicSummary[slug=advanced-spring-mvc, title=Advanced Spring MVC, difficulty=ADVANCED]

        // At this project's actual scale, a hand-written toDto(...) per entity is
        // perfectly maintainable. Larger codebases often reach for a mapping library
        // (MapStruct is the common choice -- it generates this exact kind of method
        // at compile time instead of by hand) once there are dozens of DTOs and
        // fields change often enough that keeping mappings in sync by hand gets error-prone.
    }
}
