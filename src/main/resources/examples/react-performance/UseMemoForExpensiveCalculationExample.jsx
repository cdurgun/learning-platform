import { useMemo, useState } from "react";

const courses = ["Java", "React", "Spring Boot", "PostgreSQL", "Docker"];

function sortAlphabetically(list) {
  console.log("sortAlphabetically çalıştı (pahalı işlem)");
  return [...list].sort();
}

function UseMemoForExpensiveCalculationExample() {
  const [query, setQuery] = useState("");
  const [count, setCount] = useState(0);

  // `sortAlphabetically`'nin sonucu yalnızca `courses` DEĞİŞTİĞİNDE tekrar
  // hesaplanır -- `count` değiştiğinde component yeniden render olsa bile,
  // `courses` aynı kaldığı için useMemo ÖNBELLEKTEKİ sonucu döner, sıralama
  // fonksiyonunu TEKRAR ÇALIŞTIRMAZ.
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
