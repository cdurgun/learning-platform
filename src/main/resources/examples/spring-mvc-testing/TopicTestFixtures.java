import com.cdurgun.learning.domain.Category;
import com.cdurgun.learning.domain.Course;
import com.cdurgun.learning.domain.Difficulty;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.domain.TopicTranslation;

// Bu projenin gerçek entity'leri (Topic, Category, Course, TopicTranslation) Lombok
// @Builder kullanıyor -- ekstra bir test kütüphanesi gerekmeden, okunabilir "fixture"
// (test verisi) üretmek için doğrudan kullanılabilirler. Bu sınıf, TR/EN çeviri ve
// tüm ManyToOne ilişkileriyle birlikte KENDİ İÇİNDE TUTARLI bir Topic ağacı kurar --
// aşağıdaki TopicControllerWebMvcTest bu yardımcıları kullanır.
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

        // Zincirleme ilişkinin gerçekten kurulduğunu doğrula -- entity'lerin builder'la
        // üretilmesi, aralarındaki referansları ELLE bağlamayı ortadan kaldırmaz.
        System.out.println(translation.getTopic().getCategory().getCourse().getName());
        // Java
        System.out.println(translation.getTopic().getSlug() + " -> " + translation.getTitle());
        // spring-mvc-testing -> Spring MVC'de Test Yazmak
    }
}
