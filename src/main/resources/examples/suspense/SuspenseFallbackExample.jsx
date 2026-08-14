import { lazy, Suspense } from "react";

const CourseDetails = lazy(() => import("./CourseDetails.jsx"));

function SuspenseFallbackExample() {
  return (
    // `fallback`, herhangi bir JSX olabilir -- yalnızca bir metin değil,
    // bir spinner, bir iskelet (skeleton) ekran, ya da başka bir
    // component de olabilir. Lazy Loading dersinde Suspense'i YALNIZCA
    // lazy() ile birlikte gördük -- bu ders, Suspense'in kendisine daha
    // yakından bakıyor.
    <Suspense fallback={<p className="spinner">Loading course...</p>}>
      <CourseDetails />
    </Suspense>
  );
}
