import { BrowserRouter, Routes, Route, useNavigate } from "react-router";

function CourseList() {
  const navigate = useNavigate();

  function handleSelect(courseSlug) {
    // Link her zaman bir tıklama gerektirir -- useNavigate() ise, bir
    // fonksiyon İÇİNDEN (örneğin bir event handler'dan) URL'i
    // DEĞİŞTİRMEMİZİ sağlar.
    navigate(`/courses/${courseSlug}`);
  }

  return (
    <div>
      <button onClick={() => handleSelect("java")}>Go to Java</button>
      <button onClick={() => handleSelect("react")}>Go to React</button>
    </div>
  );
}

function CourseDetail() {
  return <h1>Course Detail</h1>;
}

function UseNavigateExample() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/courses" element={<CourseList />} />
        <Route path="/courses/:courseSlug" element={<CourseDetail />} />
      </Routes>
    </BrowserRouter>
  );
}
