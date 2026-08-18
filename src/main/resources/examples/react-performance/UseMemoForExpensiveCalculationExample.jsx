import { useMemo, useState } from "react";

const courses = ["Java", "React", "Spring Boot", "PostgreSQL", "Docker"];

function sortAlphabetically(list) {
  console.log("sortAlphabetically ran (expensive operation)");
  return [...list].sort();
}

function UseMemoForExpensiveCalculationExample() {
  const [query, setQuery] = useState("");
  const [count, setCount] = useState(0);

  // The result of `sortAlphabetically` is only recomputed when `courses`
  // CHANGES -- even if the component re-renders because `count` changed,
  // since `courses` stayed the same, useMemo returns the CACHED result and
  // does NOT run the sort function again.
  const sortedCourses = useMemo(() => sortAlphabetically(courses), [courses]);

  const filtered = sortedCourses.filter((course) =>
    course.toLowerCase().includes(query.toLowerCase()),
  );

  return (
    <div>
      <button onClick={() => setCount(count + 1)}>Count: {count}</button>
      <input value={query} onChange={(event) => setQuery(event.target.value)} />
      <ul>
        {filtered.map((course) => (
          <li key={course}>{course}</li>
        ))}
      </ul>
    </div>
  );
}
