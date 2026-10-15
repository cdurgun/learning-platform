package com.cdurgun.learning.service;

import com.cdurgun.learning.domain.Category;
import com.cdurgun.learning.domain.Course;
import com.cdurgun.learning.domain.Difficulty;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.Topic;
import com.cdurgun.learning.domain.TopicTranslation;
import com.cdurgun.learning.repository.CategoryRepository;
import com.cdurgun.learning.repository.CourseRepository;
import com.cdurgun.learning.repository.TopicRepository;
import com.cdurgun.learning.repository.TopicTranslationRepository;
import com.cdurgun.learning.web.nav.CourseNav;
import com.cdurgun.learning.web.nav.CourseNav.CategoryNav;
import com.cdurgun.learning.web.nav.CourseNav.TopicNavItem;
import com.cdurgun.learning.web.nav.SequencedTopic;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * {@link NavigationService}'in menü (sidebar, anasayfa ve kurs kartları) ve önceki/sonraki
 * ders sırası davranışı -- gerçek Flyway verisiyle. Beklenen değerler servisin kendi
 * repository çağrılarından değil, doğrudan SQL'den çıkarılır; böylece testler sorgu
 * stratejisi değiştiğinde (ör. N+1 yerine tek sorgu) de geçerli kalır.
 *
 * <p>Yayında olmayan çeviri, boş kategori ve boş kurs senaryoları gerçek veride kalıcı
 * olarak bulunmadığı için test içinde kurulur; her test sonunda geri alınır.</p>
 */
@SpringBootTest
@ActiveProfiles("test")
@Transactional
class NavigationServiceTest {

    private static final LocalDate DATE = LocalDate.of(2026, 10, 15);

    @Autowired
    private NavigationService navigationService;
    @Autowired
    private CourseRepository courseRepository;
    @Autowired
    private CategoryRepository categoryRepository;
    @Autowired
    private TopicRepository topicRepository;
    @Autowired
    private TopicTranslationRepository topicTranslationRepository;
    @Autowired
    private JdbcTemplate jdbcTemplate;

    /** Menüdeki bir dersin kurs/kategori bağlamıyla birlikte düz hâli. */
    private record Row(String course, String category, String topic, String title, String summary,
                       String difficulty, Integer estimatedMinutes) {
    }

    @Test
    void navigationListsExactlyThePublishedTranslationsInSortOrder() {
        for (Language language : Language.values()) {
            List<Row> expected = jdbcTemplate.query("""
                    select c.slug as course, cat.slug as category, t.slug as topic, tt.title, tt.summary,
                           t.difficulty, t.estimated_minutes
                    from topic_translation tt
                    join topic t on t.id = tt.topic_id
                    join category cat on cat.id = t.category_id
                    join course c on c.id = cat.course_id
                    where tt.language = ? and tt.published = true
                    order by c.sort_order, cat.sort_order, t.sort_order
                    """,
                    (rs, i) -> new Row(rs.getString("course"), rs.getString("category"), rs.getString("topic"),
                            rs.getString("title"), rs.getString("summary"), rs.getString("difficulty"),
                            (Integer) rs.getObject("estimated_minutes")),
                    language.getCode());

            List<CourseNav> nav = navigationService.buildNavigation(language);

            assertThat(flatten(nav)).as(language.getCode()).isNotEmpty().containsExactlyElementsOf(expected);
            // Her kurs ve kurs içindeki her kategori ağaçta tek bir kez, tek bir blok olarak yer alır.
            assertThat(nav).extracting(CourseNav::slug).as(language.getCode()).doesNotHaveDuplicates();
            nav.forEach(course -> assertThat(course.categories()).extracting(CategoryNav::slug)
                    .as(language.getCode() + "/" + course.slug()).doesNotHaveDuplicates());
        }
    }

    @Test
    void courseAndCategoryNamesFollowTheLanguage() {
        assertThat(courseNamed("ai", Language.TR).name()).isEqualTo("Yapay Zeka");
        assertThat(courseNamed("ai", Language.EN).name()).isEqualTo("Artificial Intelligence");
        assertThat(categoryNamed("java", "control-flow", Language.TR).name()).isEqualTo("Kontrol Akışı");
        assertThat(categoryNamed("java", "control-flow", Language.EN).name()).isEqualTo("Control Flow");
    }

    @Test
    void onlyPublishedTranslationsOfTheRequestedLanguageAreListed() {
        Course course = course("nav-test-course", "Nav Test Course", 100);
        Category category = category(course, "nav-test-category", "Nav Test Category", 1);
        // Kayıt sırası sort_order'dan bilerek farklı.
        Topic bothPublished = topic(category, "nav-test-both", 2);
        Topic englishDraft = topic(category, "nav-test-en-draft", 3);
        Topic turkishOnly = topic(category, "nav-test-tr-only", 1);
        translation(bothPublished, Language.EN, "Both EN", true);
        translation(bothPublished, Language.TR, "Both TR", true);
        translation(englishDraft, Language.EN, "Draft EN", false);
        translation(englishDraft, Language.TR, "Draft TR", true);
        translation(turkishOnly, Language.TR, "Only TR", true);

        assertThat(topicSlugs(courseNamed("nav-test-course", Language.EN)))
                .containsExactly("nav-test-both");
        assertThat(topicSlugs(courseNamed("nav-test-course", Language.TR)))
                .containsExactly("nav-test-tr-only", "nav-test-both", "nav-test-en-draft");

        TopicNavItem english = courseNamed("nav-test-course", Language.EN).categories().get(0).topics().get(0);
        assertThat(english.title()).isEqualTo("Both EN");
        assertThat(english.summary()).isEqualTo("Both EN summary");
        assertThat(english.difficulty()).isEqualTo("BEGINNER");
        assertThat(english.estimatedMinutes()).isEqualTo(15);
        assertThat(courseNamed("nav-test-course", Language.TR).categories().get(0).topics().get(1).title())
                .isEqualTo("Both TR");
    }

    @Test
    void categoriesAndCoursesWithoutPublishedTopicsAreDropped() {
        Course partial = course("nav-test-partial", "Nav Test Partial", 100);
        Category draftOnly = category(partial, "nav-test-draft-only", "Nav Test Draft Only", 1);
        Category noTopics = category(partial, "nav-test-no-topics", "Nav Test No Topics", 2);
        Category published = category(partial, "nav-test-published", "Nav Test Published", 3);
        Topic draft = topic(draftOnly, "nav-test-draft", 1);
        translation(draft, Language.EN, "Draft EN", false);
        translation(draft, Language.TR, "Draft TR", false);
        Topic live = topic(published, "nav-test-live", 1);
        translation(live, Language.EN, "Live EN", true);

        Course empty = course("nav-test-empty", "Nav Test Empty", 101);
        Category emptyCategory = category(empty, "nav-test-empty-category", "Nav Test Empty Category", 1);
        Topic emptyDraft = topic(emptyCategory, "nav-test-empty-draft", 1);
        translation(emptyDraft, Language.EN, "Empty Draft EN", false);
        category(empty, "nav-test-empty-no-topics", "Nav Test Empty No Topics", 2);

        // Kategori ve kurs adının çevirisi yoksa veritabanındaki ad kullanılır.
        CourseNav english = courseNamed("nav-test-partial", Language.EN);
        assertThat(english.name()).isEqualTo("Nav Test Partial");
        assertThat(english.categories()).extracting(CategoryNav::slug).containsExactly("nav-test-published");
        assertThat(english.categories().get(0).name()).isEqualTo("Nav Test Published");

        assertThat(findCourse("nav-test-partial", Language.TR)).isEmpty();
        assertThat(findCourse("nav-test-empty", Language.EN)).isEmpty();
        assertThat(findCourse("nav-test-empty", Language.TR)).isEmpty();
    }

    @Test
    void courseSequenceFollowsCategoryThenTopicOrderForEachLanguage() {
        Long javaId = courseRepository.findBySlug("java").orElseThrow().getId();
        for (Language language : Language.values()) {
            List<SequencedTopic> expected = jdbcTemplate.query("""
                    select t.slug, tt.title
                    from topic_translation tt
                    join topic t on t.id = tt.topic_id
                    join category cat on cat.id = t.category_id
                    where cat.course_id = ? and tt.language = ? and tt.published = true
                    order by cat.sort_order, t.sort_order
                    """,
                    (rs, i) -> new SequencedTopic(rs.getString("slug"), rs.getString("title")),
                    javaId, language.getCode());

            assertThat(navigationService.buildCourseSequence(javaId, language)).as(language.getCode())
                    .isNotEmpty().containsExactlyElementsOf(expected);
        }
    }

    @Test
    void courseSequenceCrossesCategoriesAndSkipsUnpublishedTopics() {
        Course course = course("nav-test-sequence", "Nav Test Sequence", 100);
        Category second = category(course, "nav-test-seq-second", "Second", 2);
        Category first = category(course, "nav-test-seq-first", "First", 1);
        translation(topic(second, "nav-test-seq-c", 1), Language.EN, "C", true);
        translation(topic(first, "nav-test-seq-b", 2), Language.EN, "B", true);
        translation(topic(first, "nav-test-seq-a", 1), Language.EN, "A", true);
        translation(topic(first, "nav-test-seq-draft", 3), Language.EN, "Draft", false);

        assertThat(navigationService.buildCourseSequence(course.getId(), Language.EN)).containsExactly(
                new SequencedTopic("nav-test-seq-a", "A"),
                new SequencedTopic("nav-test-seq-b", "B"),
                new SequencedTopic("nav-test-seq-c", "C"));
        assertThat(navigationService.buildCourseSequence(course.getId(), Language.TR)).isEmpty();
    }

    private static List<Row> flatten(List<CourseNav> nav) {
        List<Row> rows = new ArrayList<>();
        for (CourseNav course : nav) {
            for (CategoryNav category : course.categories()) {
                for (TopicNavItem topic : category.topics()) {
                    rows.add(new Row(course.slug(), category.slug(), topic.slug(), topic.title(), topic.summary(),
                            topic.difficulty(), topic.estimatedMinutes()));
                }
            }
        }
        return rows;
    }

    private static List<String> topicSlugs(CourseNav course) {
        return course.categories().stream().flatMap(c -> c.topics().stream()).map(TopicNavItem::slug).toList();
    }

    private Optional<CourseNav> findCourse(String slug, Language language) {
        return navigationService.buildNavigation(language).stream().filter(c -> c.slug().equals(slug)).findFirst();
    }

    private CourseNav courseNamed(String slug, Language language) {
        return findCourse(slug, language).orElseThrow(() -> new AssertionError("menüde yok: " + slug));
    }

    private CategoryNav categoryNamed(String courseSlug, String categorySlug, Language language) {
        return courseNamed(courseSlug, language).categories().stream()
                .filter(c -> c.slug().equals(categorySlug)).findFirst()
                .orElseThrow(() -> new AssertionError("menüde yok: " + categorySlug));
    }

    private Course course(String slug, String name, int sortOrder) {
        return courseRepository.save(Course.builder().slug(slug).name(name).sortOrder(sortOrder).build());
    }

    private Category category(Course course, String slug, String name, int sortOrder) {
        return categoryRepository.save(Category.builder().course(course).slug(slug).name(name).sortOrder(sortOrder).build());
    }

    private Topic topic(Category category, String slug, int sortOrder) {
        return topicRepository.save(Topic.builder().category(category).slug(slug).difficulty(Difficulty.BEGINNER)
                .estimatedMinutes(15).sortOrder(sortOrder).build());
    }

    private void translation(Topic topic, Language language, String title, boolean published) {
        topicTranslationRepository.save(TopicTranslation.builder().topic(topic).language(language).title(title)
                .summary(title + " summary").published(published).publishedAt(DATE).updatedAt(DATE).build());
    }
}
