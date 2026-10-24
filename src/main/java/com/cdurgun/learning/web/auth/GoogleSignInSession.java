package com.cdurgun.learning.web.auth;

import com.cdurgun.learning.service.PendingGoogleSignIn;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.time.Instant;
import java.util.Optional;

/**
 * Google girişi boyunca HTTP session'da tutulan iki değer: akışın hangi dilde başladığı
 * (callback URL'i dil taşımadığı için) ve henüz tamamlanmamış Google kimliği
 * ({@link PendingGoogleSignIn}). Bekleyen kimlik yalnızca bu tarayıcının session'ına
 * bağlıdır, süresi dolunca okunmaz ve tamamlanınca/iptal edilince silinir -- başka bir
 * session'dan ya da tekrar oynatılarak kullanılamaz.
 */
public final class GoogleSignInSession {

    private static final String LANG = GoogleSignInSession.class.getName() + ".LANG";
    private static final String PENDING = GoogleSignInSession.class.getName() + ".PENDING";

    private GoogleSignInSession() {
    }

    public static void rememberLang(HttpServletRequest request, String lang) {
        request.getSession().setAttribute(LANG, lang);
    }

    /** Akışın başladığı dil; bilinmiyorsa varsayılan dil (bkz. CLAUDE.md, varsayılan İngilizce). */
    public static String lang(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object lang = session == null ? null : session.getAttribute(LANG);
        return "tr".equals(lang) ? "tr" : "en";
    }

    public static void storePending(HttpServletRequest request, PendingGoogleSignIn pending) {
        request.getSession().setAttribute(PENDING, pending);
    }

    /** Süresi dolmuş bir kayıt da burada silinir ve boş döner. */
    public static Optional<PendingGoogleSignIn> pending(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || !(session.getAttribute(PENDING) instanceof PendingGoogleSignIn pending)) {
            return Optional.empty();
        }
        if (pending.isExpired(Instant.now())) {
            session.removeAttribute(PENDING);
            return Optional.empty();
        }
        return Optional.of(pending);
    }

    public static void clear(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute(PENDING);
            session.removeAttribute(LANG);
        }
    }
}
