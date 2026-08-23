package com.cdurgun.learning.web.ingest;

/**
 * Ingestion isteğindeki tek bir şık. {@code correct} burada BİLİNÇLİ OLARAK var
 * (public quiz DTO'larındaki {@code QuizOptionView}'ın aksine) -- bu, AI/n8n'in
 * doğru cevabı BİLDİRDİĞİ tarafın verisi, gizlenmesi gereken client-facing bir
 * görünüm değil.
 */
public record QuestionIngestOption(String optionText, boolean correct) {
}
