const BASE_URL = "http://localhost:3000";

function DeleteCourseExample({ courses, setCourses }) {
  async function handleDelete(courseId) {
    await fetch(`${BASE_URL}/courses/${courseId}`, { method: "DELETE" });

    // Sunucudan sildikten SONRA, ekrandaki listeyi de güncellememiz gerekir
    // -- State dersindeki immutability kuralına uyarak, silinen kaydı
    // filter() ile ÇIKARIP yeni bir dizi oluşturuyoruz.
    setCourses(courses.filter((course) => course.id !== courseId));
  }

  return (
    <ul>
      {courses.map((course) => (
        <li key={course.id}>
          {course.name}
          <button onClick={() => handleDelete(course.id)}>Delete</button>
        </li>
      ))}
    </ul>
  );
}
