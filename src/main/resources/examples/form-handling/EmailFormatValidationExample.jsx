import { useState } from "react";

function EmailFormatValidationExample() {
  const [email, setEmail] = useState("");
  const [error, setError] = useState("");

  // A simple email format check -- real projects may have more
  // comprehensive rules; here we only check for "@" and a dot.
  const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

  function handleSubmit(event) {
    event.preventDefault();

    if (!emailPattern.test(email)) {
      setError("Enter a valid email address.");
      return;
    }

    setError("");
    console.log("Valid email:", email);
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="email"
        value={email}
        onChange={(event) => setEmail(event.target.value)}
        placeholder="Email"
      />
      <button type="submit">Submit</button>

      {error && <p className="error">{error}</p>}
    </form>
  );
}
