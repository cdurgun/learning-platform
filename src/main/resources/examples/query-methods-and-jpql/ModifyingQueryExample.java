import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

// A plausible extension to this project's real QuestionRepository: bulk-
// rejecting AI-submitted questions that have sat in PENDING_REVIEW too
// long, instead of loading every one of them into Java, changing a field,
// and saving each back individually.
interface QuestionModifyingRepositoryExample extends JpaRepository<QuestionExample, Long> {

    // @Query here is an UPDATE statement, not a SELECT -- @Modifying is
    // REQUIRED to tell Spring Data JPA "this isn't a normal read, execute
    // it as a bulk update/delete instead." Without @Modifying, Spring Data
    // JPA would try to treat the result as a list of entities and fail.
    //
    // @Transactional is also required: a modifying query runs directly
    // against the database, bypassing the persistence context's usual
    // change-tracking entirely -- it needs an active transaction the same
    // way any other write does, exactly as covered in "Transaction
    // Management."
    @Modifying
    @Transactional
    @Query("update QuestionExample q set q.status = 'REJECTED' " +
            "where q.status = 'PENDING_REVIEW' and q.createdAt < :cutoff")
    int rejectStalePendingReview(@Param("cutoff") LocalDateTime cutoff);
}

class QuestionExample {
}
