import { useEffect, useState } from "react";

function BasicFetchGetExample() {
  const [courses, setCourses] = useState([]);

  // useEffect, component ekrana ilk geldiğinde (boş dependency array []) BİR
  // KEZ çalışır -- veri çekmek için en yaygın kullanım budur. fetch(), bir
  // Promise döner; .then() ile önce yanıtı JSON'a çeviriyoruz, sonra state'e
  // yazıyoruz.
  useEffect(() => {
    fetch("/api/courses")
      .then((response) => response.json())
      .then((data) => setCourses(data));
  }, []);

  return (
    <ul>
      {courses.map((course) => (
        <li key={course.id}>{course.name}</li>
      ))}
    </ul>
  );
}
