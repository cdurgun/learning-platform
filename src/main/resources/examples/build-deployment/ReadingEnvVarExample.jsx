// Vite, sadece "VITE_" ile başlayan ortam değişkenlerini istemci koduna gömer --
// build sırasında import.meta.env üzerinden okunurlar. Değer .env dosyasından
// (yerel geliştirme) ya da Vercel'in "Environment Variables" ayarından
// (production) gelir; tanımlı değilse `??` ile bir varsayılana düşülür.
const appVersion = import.meta.env.VITE_APP_VERSION ?? "dev";

function VersionBadge() {
  return <span className="badge">v{appVersion}</span>;
}

export default VersionBadge;
