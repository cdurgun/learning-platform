import { lazy, Suspense } from "react";
import { BrowserRouter, Routes, Route } from "react-router";

// In the Routing lesson we loaded every page with a regular import -- in
// a real app, we don't want to download the code for pages the user
// might never visit BEFORE they navigate to that page. With lazy() we can
// turn each page into a separate bundle and only download it when that
// route is actually visited.
const CoursesPage = lazy(() => import("./CoursesPage.jsx"));
const AboutPage = lazy(() => import("./AboutPage.jsx"));

function RouteBasedCodeSplittingExample() {
  return (
    <BrowserRouter>
      {/* Suspense wraps AROUND Routes -- no matter which page is visited,
          a SINGLE fallback is shown until that page's code is loaded. */}
      <Suspense fallback={<p>Loading page...</p>}>
        <Routes>
          <Route path="/courses" element={<CoursesPage />} />
          <Route path="/about" element={<AboutPage />} />
        </Routes>
      </Suspense>
    </BrowserRouter>
  );
}
