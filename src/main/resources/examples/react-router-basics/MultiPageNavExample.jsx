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

      {/* Three separate pages, three separate Routes -- each renders its
          own component, and React switches between them as the URL
          changes. */}
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/courses" element={<Courses />} />
        <Route path="/about" element={<About />} />
      </Routes>
    </BrowserRouter>
  );
}
