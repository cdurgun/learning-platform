import { useState } from "react";

function EmailFormatValidationExample() {
  const [email, setEmail] = useState("");
  const [error, setError] = useState("");

  // Basit bir e-posta biçimi kontrolü -- gerçek projelerde daha kapsamlı
  // kurallar da olabilir, burada yalnızca "@" ve bir nokta var mı bakıyoruz.
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  function handleSubmit(event) {
    event.preventDefault();

    if (!emailPattern.test(email)) {
      setError("Geçerli bir e-posta adresi gir.");
      return;
    }

    setError("");
    console.log("Geçerli e-posta:", email);
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="email"
        value={email}
        onChange={(event) => setEmail(event.target.value)}
        placeholder="E-posta"
      />
      <button type="submit">Gönder</button>

      {error && <p className="error">{error}</p>}
    </form>
  );
}
