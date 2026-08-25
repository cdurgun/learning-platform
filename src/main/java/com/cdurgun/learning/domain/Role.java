package com.cdurgun.learning.domain;

/**
 * Kullanıcı rolü. İlk sürümde tek bir gerçek anlamı var: {@link #USER} —
 * girişli her kullanıcının varsayılanı. {@link #ADMIN} şimdilik hiçbir yerde
 * kullanılmıyor, ileride bir yönetim arayüzü eklenirse diye şema/entity
 * seviyesinde hazır tutuluyor (bkz. auth planı: "role" alanı zorunlu istendi).
 */
public enum Role {
    USER,
    ADMIN
}
