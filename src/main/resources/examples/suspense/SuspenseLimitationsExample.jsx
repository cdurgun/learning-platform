import { Suspense, useEffect, useState } from "react";

function CourseListWithEffect() {
  const [courses, setCourses] = useState(null);

  // ÖNEMLİ: useEffect + fetch (API & Data Fetching dersindeki desen),
  // Suspense'i OTOMATİK OLARAK TETİKLEMEZ -- Suspense yalnızca use() gibi,
  // React'in DOĞRUDAN tanıdığı bir Promise kaynağıyla çalışır. Bu yüzden
  // burada `courses` state'i null'ken, dışarıdaki Suspense'in fallback'i
  // GÖRÜNMEZ -- component `null` render eder, Suspense'in haberi bile
  // olmaz.
  useEffect(() => {
    fetch("http://localhost:3000/courses")
      .then((response) => response.json())
      .then((data) => setCourses(data));
  }, []);

  if (!courses) {
    // Suspense'in fallback'i değil, kendi manuel loading kontrolümüz.
    return null;
  }

  return (
    <ul>
      {courses.map((course) => (
        <li key={course.id}>{course.name}</li>
      ))}
    </ul>
  );
}

function SuspenseLimitationsExample() {
  return (
    <Suspense fallback={<p>This fallback never shows for CourseListWithEffect.</p>}>
      <CourseListWithEffect />
    </Suspense>
  );
}
