package com.cdurgun.learning.repository;

import com.cdurgun.learning.domain.AiUsageLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public interface AiUsageLogRepository extends JpaRepository<AiUsageLog, Long> {

    /**
     * {@code from} (UTC, dahil) anından bu yana kaydedilen tüm tahmini maliyetlerin toplamı.
     * Hiç satır yoksa harcama gerçekten sıfırdır. Bilinmeyen kullanımlı satırlar zaten en kötü
     * durum tutarıyla kayıtlı olduğu için toplama eksik değil, yüksek tarafta girer.
     */
    @Query("select coalesce(sum(l.estimatedCostUsd), 0) from AiUsageLog l where l.createdAt >= :from")
    BigDecimal sumEstimatedCostSince(@Param("from") LocalDateTime from);

    List<AiUsageLog> findByUserIdOrderByCreatedAtAsc(Long userId);
}
