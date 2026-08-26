package com.cdurgun.learning.web.review;

import com.cdurgun.learning.domain.Difficulty;
import com.cdurgun.learning.domain.Language;
import com.cdurgun.learning.domain.QuestionSource;
import com.cdurgun.learning.domain.QuestionStatus;
import com.cdurgun.learning.domain.QuestionType;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Question Review ekranı için salt-okunur view -- {@code web/quiz} paketindeki public
 * DTO'lardan (örn. {@code QuizOptionView}) BİLİNÇLİ OLARAK AYRI: bu, kimlik doğrulanmış
 * bir ADMIN'e gösterilen bir görünüm, doğruluk bilgisini gizlemenin hiçbir anlamı yok --
 * tam tersine reviewer'ın TAM OLARAK hangi şıkkın doğru işaretlendiğini görmesi gerekiyor.
 * Entity'nin kendisi template'e hiç sızmıyor (proje konvansiyonu).
 */
public record QuestionReviewView(
        Long id,
        String question,
        String explanation,
        String codeSnippet,
        String codeLanguage,
        QuestionType type,
        Difficulty difficulty,
        Language language,
        QuestionSource source,
        QuestionStatus status,
        String topicSlug,
        String topicTitle,
        LocalDateTime createdAt,
        List<ReviewOptionView> options) {

    /**
     * {@code question}'ın ekranda gösterilecek hâli -- bazı AI-üretilmiş CODE_OUTPUT
     * sorularında (bkz. büyük ölçekli soru üretim workflow'unun ilk gerçek OpenAI
     * çalıştırması, id 44) model, kodu HEM {@code codeSnippet}'e HEM de {@code
     * question} metninin içine bir ```` ``` ````-fenced blok olarak gömerek
     * yazıyor -- bu yüzden şablon kodu iki kez (biri düz metin olarak, ters
     * tırnaklarla birlikte; biri {@code codeSnippet}'ten doğru highlight.js
     * render'ıyla) gösteriyordu. Bu yalnızca bir GÖRÜNÜM yardımcı metodu -- DB'deki
     * {@code question} sütununu HİÇ değiştirmiyor/UPDATE etmiyor, yalnızca
     * {@code codeSnippet} zaten doluysa (yani soru gerçekten CODE_OUTPUT ise --
     * ingestion doğrulaması {@code codeSnippet}'i başka hiçbir tip için izin
     * vermiyor) metindeki fenced bloğu ekrandan düşürüyor, kodun tek kaynağı
     * {@code codeSnippet} olarak kalıyor.
     */
    public String questionDisplayText() {
        if (codeSnippet == null || codeSnippet.isBlank() || question == null) {
            return question;
        }
        String stripped = question.replaceAll("(?s)```[a-zA-Z0-9]*\\r?\\n?.*?```", "").strip();
        return stripped.isEmpty() ? question : stripped;
    }

    public record ReviewOptionView(Long id, String optionText, boolean correct) {
    }
}
