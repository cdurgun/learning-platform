import { useState } from "react";

const courses = ["Java", "React", "Spring Boot"];

function SearchBox({ query, onQueryChange }) {
  return (
    <input
      type="text"
      value={query}
      onChange={(event) => onQueryChange(event.target.value)}
      placeholder="Search courses..."
    />
  );
}

function ResultsList({ query }) {
  const filtered = courses.filter((course) =>
    course.toLowerCase().includes(query.toLowerCase()),
  );

  return (
    <ul>
      {filtered.map((course) => (
        <li key={course}>{course}</li>
      ))}
    </ul>
  );
}

function LiftingStateUpExample() {
  // `query` state'i artık SearchBox'ın İÇİNDE değil, ikisinin de ORTAK
  // atası olan bu component'te yaşıyor -- "state'i yukarı taşımak"
  // (lifting state up) dediğimiz şey bu. Her iki child da bu state'i
  // props ile alıyor.
  const [query, setQuery] = useState("");

  return (
    <div>
      <SearchBox query={query} onQueryChange={setQuery} />
      <ResultsList query={query} />
    </div>
  );
}
