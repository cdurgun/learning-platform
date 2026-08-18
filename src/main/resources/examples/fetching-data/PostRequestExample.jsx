import { useState } from "react";

function PostRequestExample() {
  const [name, setName] = useState("");

  function handleSubmit(event) {
    event.preventDefault();

    // For POST requests, we write the data to send into `body` as a JSON
    // string -- and tell the server it's JSON via the `Content-Type` header.
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
