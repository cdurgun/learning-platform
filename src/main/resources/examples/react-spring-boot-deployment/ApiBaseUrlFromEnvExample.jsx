// Build & Deployment dersindeki desenin aynısı -- ama bu kez değer, deploy
// edilmiş bir Spring Boot API'sinin GERÇEK adresi. Yerelde (localhost:8080'de
// çalışan backend'e karşı) ve production'da (Render'ın verdiği adrese karşı)
// AYNI kod, farklı bir .env / Vercel ortam değişkeni değeriyle çalışır.
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL ?? "http://localhost:8080";

function ApiAddress() {
  return (
    <p>
      Data from <code>{API_BASE_URL}</code>
    </p>
  );
}

export default ApiAddress;
