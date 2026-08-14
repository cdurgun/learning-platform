import { useState } from "react";

const BASE_URL = "http://localhost:3000";

function CreateCourseFormExample({ onCreated }) {
  const [name, setName] = useState("");

  async function handleSubmit(event) {
    event.preventDefault();

    // Forms dersindeki controlled input + onSubmit deseni, burada bir POST
    // isteğiyle birleşiyor. Spring Boot tarafında bu, `@RequestBody` ile
    // JSON'ı bir Java nesnesine çeviren bir `@PostMapping` metoduna karşılık
    // gelir (bkz. REST API Tasarımı dersi, Java kursunda).
    const response = await fetch(`${BASE_URL}/courses`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name }),
    });
    const newCourse = await response.json();

    onCreated(newCourse);
    setName("");
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        value={name}
        onChange={(event) => setName(event.target.value)}
        placeholder="Course name"
      />
      <button type="submit">Add Course</button>
    </form>
  );
}
