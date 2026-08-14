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

function ResultsPanel({ query }) {
  // ResultsPanel, `query`'i KENDİSİ hiç kullanmıyor -- yalnızca
  // ResultsList'e ULAŞTIRMAK için alıyor. Bu, "props drilling" (props'u
  // zorunlu olarak ara katmanlardan geçirmek) dediğimiz durumun basit
  // bir örneği.
  return (
    <div className="panel">
      <ResultsList query={query} />
    </div>
  );
}

function PropsDrillingExample() {
  const [query, setQuery] = useState("");

  return (
    <div>
      <SearchBox query={query} onQueryChange={setQuery} />
      <ResultsPanel query={query} />
    </div>
  );
}
