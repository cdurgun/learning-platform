import { useState } from "react";

function RequiredFieldValidationExample() {
  const [name, setName] = useState("");
  const [error, setError] = useState("");

  function handleSubmit(event) {
    event.preventDefault();

    if (name.trim() === "") {
      setError("Name cannot be empty.");
      return;
    }

    setError("");
    console.log("Form submitted:", name);
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        value={name}
        onChange={(event) => setName(event.target.value)}
        placeholder="Name"
      />
      <button type="submit">Submit</button>

      {error && <p className="error">{error}</p>}
    </form>
  );
}
