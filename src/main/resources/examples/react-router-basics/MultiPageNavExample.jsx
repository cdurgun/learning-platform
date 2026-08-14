import { BrowserRouter, Routes, Route, Link } from "react-router";

function Home() {
  return <h1>Home</h1>;
}

function Courses() {
  return <h1>Courses</h1>;
}

function About() {
  return <h1>About</h1>;
}

function MultiPageNavExample() {
  return (
    <BrowserRouter>
      <nav>
        <Link to="/">Home</Link>
        <Link to="/courses">Courses</Link>
        <Link to="/about">About</Link>
      </nav>

      {/* Üç ayrı sayfa, üç ayrı Route -- her biri kendi component'ini
          render ediyor, URL değiştikçe React aralarında geçiş yapıyor. */}
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/courses" element={<Courses />} />
        <Route path="/about" element={<About />} />
      </Routes>
    </BrowserRouter>
  );
}
