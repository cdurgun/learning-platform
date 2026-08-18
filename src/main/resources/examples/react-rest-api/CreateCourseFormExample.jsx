import { useState } from "react";

const BASE_URL = "http://localhost:3000";

function CreateCourseFormExample({ onCreated }) {
  const [name, setName] = useState("");

  async function handleSubmit(event) {
    event.preventDefault();

    // The controlled input + onSubmit pattern from the Forms lesson is
    // combined here with a POST request. On the Spring Boot side, this
    // corresponds to a `@PostMapping` method that uses `@RequestBody` to
    // convert the JSON into a Java object (see the REST API Design lesson
    // in the Java course).
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
