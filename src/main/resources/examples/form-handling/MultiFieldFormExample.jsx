import { useState } from "react";

function MultiFieldFormExample() {
  // Her alan için ayrı bir useState açmak yerine, TÜM alanları tek bir
  // state nesnesinde tutuyoruz -- form büyüdükçe daha yönetilebilir.
  const [formData, setFormData] = useState({ name: "", email: "" });

  function handleChange(event) {
    const { name, value } = event.target;

    // Hangi input değiştiyse (input'un `name` attribute'una bakarak),
    // yalnızca o alanı güncelliyoruz, diğerlerini olduğu gibi kopyalıyoruz.
    setFormData({ ...formData, [name]: value });
  }

  return (
    <form>
      <input
        type="text"
        name="name"
        value={formData.name}
        onChange={handleChange}
        placeholder="İsim"
      />
      <input
        type="email"
        name="email"
        value={formData.email}
        onChange={handleChange}
        placeholder="E-posta"
      />
      <p>
        {formData.name} / {formData.email}
      </p>
    </form>
  );
}
