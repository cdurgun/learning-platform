package com.cdurgun.learning.service;

import java.io.Serializable;
import java.time.Duration;
import java.time.Instant;

/**
 * Google'ın doğruladığı, ama henüz hiçbir yerel hesaba bağlı OLMAYAN bir kimlik --
 * kullanıcı ya Kullanım Koşulları'nı kabul edip yeni hesap açana ya da e-postası eşleşen
 * mevcut hesabın şifresini girip bağlayana kadar YALNIZCA o tarayıcının HTTP session'ında
 * durur (bkz. {@code GoogleSignInSession}). Bu süre boyunca kullanıcı giriş yapmış
 * sayılmaz ve DB'ye hiçbir şey yazılmaz.
 *
 * <p>{@code subject}, {@code email} ve {@code displayName} yalnızca imzası doğrulanmış
 * ID token'dan gelir -- istemciden gelen hiçbir değer buraya giremez.</p>
 */
public record PendingGoogleSignIn(String subject,
                                  String email,
                                  String displayName,
                                  Instant createdAt,
                                  int failedPasswordAttempts) implements Serializable {

    /** Bekleyen bir Google girişinin tamamlanabileceği süre. */
    public static final Duration TIME_TO_LIVE = Duration.ofMinutes(10);

    /** Bu kadar yanlış şifreden sonra bekleyen giriş silinir, kullanıcı baştan başlar. */
    public static final int MAX_PASSWORD_ATTEMPTS = 5;

    public static PendingGoogleSignIn of(String subject, String email, String displayName, Instant now) {
        return new PendingGoogleSignIn(subject, email, displayName, now, 0);
    }

    public boolean isExpired(Instant now) {
        return now.isAfter(createdAt.plus(TIME_TO_LIVE));
    }

    public PendingGoogleSignIn withFailedPasswordAttempt() {
        return new PendingGoogleSignIn(subject, email, displayName, createdAt, failedPasswordAttempts + 1);
    }

    public boolean attemptsExhausted() {
        return failedPasswordAttempts >= MAX_PASSWORD_ATTEMPTS;
    }
}
