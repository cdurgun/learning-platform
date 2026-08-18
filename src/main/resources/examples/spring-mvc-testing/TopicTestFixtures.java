import com.cdurgun.learning.domain.Category;
import com.cdurgun.learning.domain.Course;
import com.cdurgun.learning.domain.Difficulty;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.domain.TopicTranslation;

// This project's real entities (Topic, Category, Course, TopicTranslation) use Lombok
// @Builder -- they can be used directly to produce readable "fixtures" (test data)
// without needing an extra test library. This class builds a SELF-CONSISTENT Topic
// tree, complete with a TR/EN translation and all its ManyToOne relationships -- the
// TopicControllerWebMvcTest below uses these helpers.
public class TopicTestFixtures {

    public static Course sampleCourse() {
        return Course.builder()
                .id(1L)
                .name("Java")
                .slug("java")
                .build();
    }

    public static Category sampleCategory(Course course) {
        return Category.builder()
                .id(1L)
                .course(course)
                .name("Spring MVC")
                .slug("spring-mvc")
                .sortOrder(1)
                .build();
    }

    public static Topic sampleTopic(Category category) {
        return Topic.builder()
                .id(9L)
                .category(category)
                .slug("spring-mvc-testing")
                .difficulty(Difficulty.ADVANCED)
                .estimatedMinutes(40)
                .sortOrder(9)
                .build();
    }

    public static TopicTranslation sampleTranslation(Topic topic, Language language, boolean published) {
        return TopicTranslation.builder()
                .id(language == Language.TR ? 91L : 92L)
                .topic(topic)
                .language(language)
                .title(language == Language.TR ? "Spring MVC'de Test Yazmak" : "Testing in Spring MVC")
                .summary(language == Language.TR ? "MockMvc ve @WebMvcTest ile web katmanı testleri." : "Web layer testing with MockMvc and @WebMvcTest.")
                .published(published)
                .build();
    }

    public static void main(String[] args) {
        Course course = sampleCourse();
        Category category = sampleCategory(course);
        Topic topic = sampleTopic(category);
        TopicTranslation translation = sampleTranslation(topic, Language.TR, true);

        // Verify that the chained relationship was actually established -- producing
        // entities with a builder doesn't eliminate the need to wire the references
        // between them BY HAND.
        System.out.println(translation.getTopic().getCategory().getCourse().getName());
        // Java
        System.out.println(translation.getTopic().getSlug() + " -> " + translation.getTitle());
        // spring-mvc-testing -> Spring MVC'de Test Yazmak
    }
}
