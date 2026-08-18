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
  // The `query` state no longer lives INSIDE SearchBox -- it now lives in
  // this component, the COMMON ancestor of both. This is what we call
  // "lifting state up". Both children receive this state via props.
  const [query, setQuery] = useState("");

  return (
    <div>
      <SearchBox query={query} onQueryChange={setQuery} />
      <ResultsList query={query} />
    </div>
  );
}
