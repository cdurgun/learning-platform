import { BrowserRouter, Routes, Route } from "react-router";

function Home() {
  return <h1>Home Page</h1>;
}

function Courses() {
  return <h1>Courses Page</h1>;
}

function BasicRouterSetupExample() {
  return (
    <BrowserRouter>
      {/* Routes, URL'e göre HANGİ Route'un render edileceğine karar verir --
          aynı anda yalnızca eşleşen bir tane render edilir. */}
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/courses" element={<Courses />} />
      </Routes>
    </BrowserRouter>
  );
}
