import { useEffect, useState } from "react";

function LoadingStateExample() {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch("/api/courses")
      .then((response) => response.json())
      .then((data) => {
        setCourses(data);
        setLoading(false);
      });
  }, []);

  // Veri gelene kadar ekranda bir "Loading..." mesajı göstermek, kullanıcıya
  // bir şeylerin olduğunu bildirir -- boş bir liste yerine.
  if (loading) {
    return <p>Loading...</p>;
  }

  return (
    <ul>
      {courses.map((course) => (
        <li key={course.id}>{course.name}</li>
      ))}
    </ul>
  );
}
