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
}
