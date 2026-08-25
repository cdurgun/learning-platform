-- Opsiyonel kullanıcı kimlik doğrulaması için minimum şema (bkz. SecurityConfig,
-- CustomUserDetailsService). Tablo adı bilerek "user" DEĞİL "app_user" -- "user"
-- PostgreSQL'de ayrılmış bir anahtar kelime (CURRENT_USER fonksiyonuyla çakışır),
-- her sorguda çift tırnaklamaya gerek bırakmamak için kaçınıldı.
CREATE TABLE app_user
(
    id            BIGSERIAL PRIMARY KEY,
    email         VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    display_name  VARCHAR(255) NOT NULL,
    role          VARCHAR(20)  NOT NULL DEFAULT 'USER',
    created_at    TIMESTAMP    NOT NULL DEFAULT now(),
    updated_at    TIMESTAMP    NOT NULL DEFAULT now()
);
