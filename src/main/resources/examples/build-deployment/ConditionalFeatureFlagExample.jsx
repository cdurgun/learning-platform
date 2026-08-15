// Ortam değişkenleri yalnızca metin/rozet göstermek için değil, ortama göre
// farklı davranmak (feature flag) için de kullanılır. "true" string'ini
// gerçek bir boolean'a çevirmeyi unutmamak önemli -- import.meta.env'deki
// her değer STRING'dir, "false" bile truthy'dir.
const showBetaBanner = import.meta.env.VITE_SHOW_BETA_BANNER === "true";

function BetaBanner() {
  if (!showBetaBanner) {
    return null;
  }

  return <div className="beta-banner">This is a beta build.</div>;
}

export default BetaBanner;
