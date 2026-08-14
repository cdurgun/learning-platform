import { useEffect, useState } from "react";

const BASE_URL = "http://localhost:3000";

function RefreshAfterMutationExample() {
  const [courses, setCourses] = useState([]);
  const [name, setName] = useState("");

  useEffect(() => {
    fetch(`${BASE_URL}/courses`)
      .then((response) => response.json())
      .then((data) => setCourses(data));
  }, []);

  async function handleSubmit(event) {
    event.preventDefault();

    const response = await fetch(`${BASE_URL}/courses`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name }),
    });
    const newCourse = await response.json();

    // Sunucu yeni kaydı oluşturduktan sonra, listeyi baştan çekmek yerine
    // (bir istek daha atmak yerine) State dersindeki immutability kuralına
    // uyarak yeni kaydı doğrudan mevcut listeye ekliyoruz -- ekran anında
    // güncellenir.
    setCourses([...courses, newCourse]);
    setName("");
  }

  return (
    <div>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          value={name}
          onChange={(event) => setName(event.target.value)}
          placeholder="Course name"
        />
        <button type="submit">Add</button>
      </form>
      <ul>
        {courses.map((course) => (
          <li key={course.id}>{course.name}</li>
        ))}
      </ul>
    </div>
  );
}
