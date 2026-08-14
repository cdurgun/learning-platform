import { useState } from "react";

function PostRequestExample() {
  const [name, setName] = useState("");

  function handleSubmit(event) {
    event.preventDefault();

    // POST isteklerinde, gönderilecek veriyi `body`'ye JSON string olarak
    // yazarız -- ve sunucuya bunun JSON olduğunu `Content-Type` header'ıyla
    // bildiririz.
    fetch("/api/courses", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name }),
    });
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        value={name}
        onChange={(event) => setName(event.target.value)}
        placeholder="Course name"
      />
      <button type="submit">Add</button>
    </form>
  );
}
