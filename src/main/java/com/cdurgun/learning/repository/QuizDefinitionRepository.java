package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.QuizDefinition;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface QuizDefinitionRepository extends JpaRepository<QuizDefinition, Long> {

    Optional<QuizDefinition> findBySlugAndActiveTrue(String slug);

    /**
     * Quiz Area kataloğu -- hem sidebar'daki "QUIZ" bölümü hem de {@code /quiz} index
     * sayfası bu TEK sorguyu kullanır. {@code course} join fetch edilir (N+1 önlenir),
     * sonuç kurs sırasına göre gruplanmış/sıralanmış tek düz bir liste olarak döner --
     * kursa göre gruplama çağıran tarafta (QuizNavigationService) bellek içinde yapılır,
     * NavigationService'in kendi Course→Category→Topic gezinme deseniyle tutarlı.
     */
    @Query("select qd from QuizDefinition qd join fetch qd.course c " +
            "where qd.active = true order by c.sortOrder asc, qd.sortOrder asc")
    List<QuizDefinition> findAllActiveOrderByCourseAndSortOrder();
}
