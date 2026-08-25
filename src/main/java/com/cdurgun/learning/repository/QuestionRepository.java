package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.Question;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface QuestionRepository extends JpaRepository<Question, Long> {

    /**
     * Practice havuzu sorgusu. {@code status = 'PUBLISHED'} filtresi BİLİNÇLİ OLARAK
     * bir metot parametresi DEĞİL, sorgunun kendisine sabit yazılmış (hardcoded) --
     * çağıran taraf (PracticeService) bunu hiçbir şekilde override edemez, bu yüzden
     * PENDING_REVIEW/DRAFT/REJECTED bir soru Practice'te asla görünemez (bkz. plan
     * bölüm 5.2). {@code topicId}/{@code difficulty}/{@code type} nullable -- null
     * olduklarında o filtre uygulanmaz (`:param IS NULL OR ...` deseni). {@code
     * language} zorunlu (rota her zaman {@code {lang:en|tr}} path variable'ından
     * gelir). Native query kullanılıyor çünkü JPQL'de taşınabilir bir RANDOM()
     * fonksiyonu yok; ORDER BY RANDOM() Postgres'e özgü ve idx_question_pool
     * (core/V293) tarafından aday satır sayısı zaten filtrelendiği için bu ölçekte
     * yeterli (bkz. plan bölüm 7, risk 2 -- ileride TABLESAMPLE/offset alternatifi).
     */
    @Query(value = "SELECT * FROM question q " +
            "WHERE q.status = 'PUBLISHED' " +
            "AND q.language = :language " +
            "AND (:topicId IS NULL OR q.topic_id = :topicId) " +
            "AND (:difficulty IS NULL OR q.difficulty = :difficulty) " +
            "AND (:type IS NULL OR q.type = :type) " +
            "ORDER BY RANDOM() " +
            "LIMIT :count",
            nativeQuery = true)
    List<Question> findRandomPublishedPool(@Param("topicId") Long topicId,
                                            @Param("language") String language,
                                            @Param("difficulty") String difficulty,
                                            @Param("type") String type,
                                            @Param("count") int count);

    /**
     * Quiz Area (course+category kapsamlı) havuz sorgusu -- {@link #findRandomPublishedPool}
     * ile AYNI PUBLISHED/dil/difficulty/type deseni ve AYNI native/RANDOM() gerekçesi,
     * tek fark: tek bir topicId yerine course_id + OPSİYONEL bir category_id dizisi.
     * {@code categoryIds} NULL ise (QuizDefinition'ın "boş kategori kümesi = tüm kurs"
     * kuralı, bkz. {@link com.cdurgun.learning.domain.QuizDefinition}) yalnızca course_id
     * ile filtrelenir. {@code LIMIT :count}, uygun soru sayısı {@code count}'tan azsa
     * hatasız olarak mevcut olan kadarını döner -- bu yüzden "questionCount'tan az soru
     * varsa ne olur" sorusu servis katmanında ayrı bir kontrol GEREKTİRMEZ, SQL'in kendi
     * semantiği yeterli.
     *
     * <p><b>{@code :categoryIds}'in her iki geçtiği yerde de AÇIKÇA {@code CAST(... AS
     * bigint[])} GEREKLİ</b> -- gerçek uçtan uca doğrulamada (Faz 139/Phase 6, canlı
     * uygulamaya karşı gerçek bir HTTP isteğiyle) {@code categoryIds = null} (whole-course/
     * "All X" durumu) her zaman {@code PSQLException: could not determine data type of
     * parameter $3} ile PATLADIĞI GERÇEKTEN GÖZLEMLENDİ -- Postgres'in genişletilmiş sorgu
     * protokolü, yalnızca {@code IS NULL} içinde geçen (başka hiçbir tipe bağlayıcı bağlamı
     * olmayan) bir dizi parametresinin tipini null bağlamda çıkaramıyor (skaler `text`/
     * `bigint` parametreler için JDBC sürücüsü zaten örtük bir tip ipucu veriyor, dizi
     * parametreleri için vermiyor). Cast eklenmeden ÖNCE bu, yalnızca `all-java` gibi
     * boş-kategori (whole-course) senaryosunda tetikleniyordu -- kategori-kapsamlı sorgular
     * (`categoryIds` gerçek bir dizi olduğunda) ETKİLENMİYORDU, bu yüzden yalnızca mock'lu
     * unit testlerle YAKALANAMAZDI, gerçek Postgres'e karşı çalıştırmak GEREKTİ (bkz.
     * docs/known-constraints.md).</p>
     */
    @Query(value = "SELECT q.* FROM question q " +
            "JOIN topic t ON t.id = q.topic_id " +
            "JOIN category c ON c.id = t.category_id " +
            "WHERE q.status = 'PUBLISHED' " +
            "AND q.language = :language " +
            "AND c.course_id = :courseId " +
            "AND (CAST(:categoryIds AS bigint[]) IS NULL OR c.id = ANY (CAST(:categoryIds AS bigint[]))) " +
            "AND (:difficulty IS NULL OR q.difficulty = :difficulty) " +
            "AND (:type IS NULL OR q.type = :type) " +
            "ORDER BY RANDOM() " +
            "LIMIT :count",
            nativeQuery = true)
    List<Question> findRandomPublishedPoolByCourseAndCategories(@Param("courseId") Long courseId,
                                                                  @Param("categoryIds") Long[] categoryIds,
                                                                  @Param("language") String language,
                                                                  @Param("difficulty") String difficulty,
                                                                  @Param("type") String type,
                                                                  @Param("count") int count);
}
