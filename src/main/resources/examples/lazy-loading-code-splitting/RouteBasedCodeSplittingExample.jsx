import { lazy, Suspense } from "react";
import { BrowserRouter, Routes, Route } from "react-router";

// Routing dersinde her sayfayı normal import ile yüklemiştik -- gerçek bir
// uygulamada, KULLANICI O SAYFAYA GİTMEDEN, hiç ziyaret etmeyeceği
// sayfaların kodunu indirmek istemeyiz. lazy() ile her sayfayı ayrı bir
// paket haline getirip, yalnızca o route'a gidildiğinde indirebiliriz.
const CoursesPage = lazy(() => import("./CoursesPage.jsx"));
const AboutPage = lazy(() => import("./AboutPage.jsx"));

function RouteBasedCodeSplittingExample() {
  return (
    <BrowserRouter>
      {/* Suspense, Routes'un DIŞINA sarmalanıyor -- hangi sayfaya
          gidilirse gidilsin, o sayfanın kodu yüklenene kadar TEK bir
          fallback gösterilir. */}
      <Suspense fallback={<p>Loading page...</p>}>
        <Routes>
          <Route path="/courses" element={<CoursesPage />} />
          <Route path="/about" element={<AboutPage />} />
        </Routes>
      </Suspense>
    </BrowserRouter>
  );
}
