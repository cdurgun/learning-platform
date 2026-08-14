import { BrowserRouter, Routes, Route, Link } from "react-router";

function Home() {
  return (
    <div>
      <h1>Home Page</h1>
      {/* <a href="..."> yerine <Link to="..."> kullanıyoruz -- Link, sayfayı
          YENİDEN YÜKLEMEDEN (full page reload olmadan) URL'i değiştirir,
          React sadece gerekli kısmı yeniden render eder. */}
      <Link to="/courses">View Courses</Link>
    </div>
  );
}

function Courses() {
  return (
    <div>
      <h1>Courses Page</h1>
      <Link to="/">Back to Home</Link>
    </div>
  );
}

function LinkNavigationExample() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/courses" element={<Courses />} />
      </Routes>
    </BrowserRouter>
  );
}
