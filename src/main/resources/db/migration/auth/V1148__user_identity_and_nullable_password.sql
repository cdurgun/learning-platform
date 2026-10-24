-- "Google ile devam et": bir app_user'a bağlı harici kimlikler. Google hesabı e-postayla
-- DEĞİL, değişmeyen "sub" claim'iyle tanınır (provider_subject). Yalnızca eklemeler var;
-- mevcut hiçbir satır değişmiyor.
CREATE TABLE user_identity
(
    id               BIGSERIAL PRIMARY KEY,
    user_id          BIGINT       NOT NULL REFERENCES app_user (id) ON DELETE CASCADE,
    provider         VARCHAR(20)  NOT NULL,
    provider_subject VARCHAR(255) NOT NULL,
    created_at       TIMESTAMP    NOT NULL DEFAULT now(),
    -- Bir Google hesabı yalnızca tek bir yerel hesaba bağlanabilir...
    CONSTRAINT uq_user_identity_provider_subject UNIQUE (provider, provider_subject),
    -- ...ve bir yerel hesap aynı sağlayıcıdan yalnızca tek bir hesaba.
    CONSTRAINT uq_user_identity_user_provider UNIQUE (user_id, provider)
);

-- Yalnızca Google ile açılan hesapların şifresi yok. Mevcut hesapların hash'i aynen
-- kalıyor; NULL hash'li bir hesap şifreyle giriş yapamaz (bkz. CustomUserDetailsService).
ALTER TABLE app_user
    ALTER COLUMN password_hash DROP NOT NULL;
