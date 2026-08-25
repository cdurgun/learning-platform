package com.cdurgun.learning.service;

/**
 * Kayıt sırasında zaten kullanılan bir email adresi girilirse fırlatılır —
 * {@code AuthController} bunu yakalayıp kullanıcı dostu bir form hatasına çevirir.
 */
public class DuplicateEmailException extends RuntimeException {

    public DuplicateEmailException(String email) {
        super("Email zaten kayıtlı: " + email);
    }
}
