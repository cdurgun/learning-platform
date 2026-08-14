import { BrowserRouter, Routes, Route, Link, useNavigate } from "react-router";

function CourseList() {
  return (
    <div>
      <h1>Courses</h1>
      <Link to="/courses/java">Java</Link>
    </div>
  );
}

function CourseDetail() {
  const navigate = useNavigate();

  function handleBack() {
    // navigate(-1), tarayıcının "geri" butonuyla aynı şeyi yapar --
    // history'de bir adım geriye gider. navigate(-2) iki adım geriye
    // gider, ve benzeri.
    navigate(-1);
  }

  return (
    <div>
      <h1>Course Detail</h1>
      <button onClick={handleBack}>Back</button>
    </div>
  );
}

function GoBackNavigateExample() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/courses" element={<CourseList />} />
        <Route path="/courses/:courseSlug" element={<CourseDetail />} />
      </Routes>
    </BrowserRouter>
  );
}
