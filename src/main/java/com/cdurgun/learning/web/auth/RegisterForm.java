package com.cdurgun.learning.web.auth;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

/**
 * Kayıt formu için bağlama nesnesi. Lombok POJO olarak (record DEĞİL) yazıldı --
 * Thymeleaf'in {@code th:field} mekanizması JavaBean tarzı getter/setter bekliyor,
 * form validasyon hatasında girilen değerlerin sayfada korunabilmesi için mutable
 * olması gerekiyor (bkz. {@code web/quiz}/{@code web/ingest} altındaki diğer DTO'lar
 * salt-okunur JSON gövdeleri için record kullanıyor, bu farklı bir kullanım).
 */
@Getter
@Setter
public class RegisterForm {

    @NotBlank(message = "{auth.validation.email.required}")
    @Email(message = "{auth.validation.email.invalid}")
    @Size(max = 255, message = "{auth.validation.email.invalid}")
    private String email;

    @NotBlank(message = "{auth.validation.password.required}")
    @Size(min = 8, message = "{auth.validation.password.size}")
    private String password;

    @NotBlank(message = "{auth.validation.displayName.required}")
    @Size(max = 255, message = "{auth.validation.displayName.size}")
    private String displayName;
}
