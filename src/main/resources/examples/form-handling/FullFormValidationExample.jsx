import { useState } from "react";

function FullFormValidationExample() {
  const [formData, setFormData] = useState({ name: "", email: "" });
  const [errors, setErrors] = useState({});

  function handleChange(event) {
    const { name, value } = event.target;
    setFormData({ ...formData, [name]: value });
  }

  function validate() {
    // Her alan için ayrı bir hata mesajı üretip, hataların HEPSİNİ tek bir
    // nesnede topluyoruz -- her alanın kendi hatasını göstermesini sağlar.
    const newErrors = {};

    if (formData.name.trim() === "") {
      newErrors.name = "İsim boş bırakılamaz.";
    }

    if (formData.email.trim() === "") {
      newErrors.email = "E-posta boş bırakılamaz.";
    }

    return newErrors;
  }

  function handleSubmit(event) {
    event.preventDefault();

    const newErrors = validate();
    setErrors(newErrors);

    // Nesnenin hiç anahtarı yoksa, hiç hata yok demektir.
    if (Object.keys(newErrors).length === 0) {
      console.log("Form geçerli, gönderiliyor:", formData);
    }
  }

  return (
    <form onSubmit={handleSubmit}>
      <div>
        <input
          type="text"
          name="name"
          value={formData.name}
          onChange={handleChange}
          placeholder="İsim"
        />
        {errors.name && <p className="error">{errors.name}</p>}
      </div>

      <div>
        <input
          type="email"
          name="email"
          value={formData.email}
          onChange={handleChange}
          placeholder="E-posta"
        />
        {errors.email && <p className="error">{errors.email}</p>}
      </div>

      <button type="submit">Gönder</button>
    </form>
  );
}
