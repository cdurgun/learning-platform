import { useEffect, useState } from "react";

const BASE_URL = "http://localhost:3000";

function FetchCoursesExample() {
  const [courses, setCourses] = useState([]);

  useEffect(() => {
    // useEffect'in callback'i doğrudan async OLAMAZ -- bu yüzden içeride
    // ayrı bir async fonksiyon tanımlayıp hemen çağırıyoruz. Gerçek bir
    // projede burası (Spring Boot ile) GET /api/courses'a karşılık gelir --
    // React, HTTP üzerinden backend'e istek atar, backend veritabanından
    // (PostgreSQL) okuyup JSON döner.
    async function loadCourses() {
      const response = await fetch(`${BASE_URL}/courses`);
      const data = await response.json();
      setCourses(data);
    }

    loadCourses();
  }, []);

  return (
    <ul>
      {courses.map((course) => (
        <li key={course.id}>{course.name}</li>
      ))}
    </ul>
  );
}
