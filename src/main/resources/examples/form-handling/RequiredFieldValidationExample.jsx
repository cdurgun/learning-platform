import { useState } from "react";

function RequiredFieldValidationExample() {
  const [name, setName] = useState("");
  const [error, setError] = useState("");

  function handleSubmit(event) {
    event.preventDefault();

    if (name.trim() === "") {
      setError("İsim boş bırakılamaz.");
      return;
    }

    setError("");
    console.log("Form gönderildi:", name);
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        value={name}
        onChange={(event) => setName(event.target.value)}
        placeholder="İsim"
      />
      <button type="submit">Gönder</button>

      {error && <p className="error">{error}</p>}
    </form>
  );
}
