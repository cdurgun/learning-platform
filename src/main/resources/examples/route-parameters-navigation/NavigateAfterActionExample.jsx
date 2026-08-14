import { useState } from "react";
import { BrowserRouter, Routes, Route, useNavigate } from "react-router";

function NewCourseForm() {
  const [title, setTitle] = useState("");
  const navigate = useNavigate();

  function handleSubmit(event) {
    event.preventDefault();

    // Form gönderildikten (örneğin "kaydedildikten") SONRA, kullanıcıyı
    // başka bir sayfaya yönlendirmek yaygın bir kalıptır.
    navigate("/courses");
  }

  return (
    <form onSubmit={handleSubmit}>
      <input
        type="text"
        value={title}
        onChange={(event) => setTitle(event.target.value)}
        placeholder="Course title"
      />
      <button type="submit">Save</button>
    </form>
  );
}

function CourseList() {
  return <h1>Courses</h1>;
}

function NavigateAfterActionExample() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/new-course" element={<NewCourseForm />} />
        <Route path="/courses" element={<CourseList />} />
      </Routes>
    </BrowserRouter>
  );
}
