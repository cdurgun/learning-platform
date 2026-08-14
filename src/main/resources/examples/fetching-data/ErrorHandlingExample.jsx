import { useEffect, useState } from "react";

function ErrorHandlingExample() {
  const [courses, setCourses] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetch("/api/courses")
      .then((response) => {
        if (!response.ok) {
          // fetch(), 404/500 gibi HTTP hatalarında KENDİLİĞİNDEN reddetmez
          // (reject) -- response.ok'u KONTROL ETMEK bize düşer.
          throw new Error("Request failed: " + response.status);
        }
        return response.json();
      })
      .then((data) => setCourses(data))
      .catch((err) => setError(err.message))
      .finally(() => setLoading(false));
  }, []);

  if (loading) {
    return <p>Loading...</p>;
  }

  // error state doluysa, listeyi hiç render etmeden bir hata mesajı
  // gösteriyoruz -- Conditional Rendering dersindeki if deseni.
  if (error) {
    return <p>Something went wrong: {error}</p>;
  }

  return (
    <ul>
      {courses.map((course) => (
        <li key={course.id}>{course.name}</li>
      ))}
    </ul>
  );
}
