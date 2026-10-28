package com.cdurgun.learning.web.ai;

/**
 * Hata gövdesi (plan §5): sabit bir kod ve {@code messages*.properties}'ten dile göre metin.
 * Sağlayıcının durum kodu ya da hata ayrıntısı hiçbir zaman burada yer almaz.
 */
public record TutorErrorResponse(String error, String message) {
}
