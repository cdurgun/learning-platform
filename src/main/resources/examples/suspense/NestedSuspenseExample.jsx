import { lazy, Suspense } from "react";

const CourseHeader = lazy(() => import("./CourseHeader.jsx"));
const CourseReviews = lazy(() => import("./CourseReviews.jsx"));

function NestedSuspenseExample() {
  return (
    // Dıştaki Suspense, CourseHeader yüklenene kadar TÜM sayfa için bir
    // fallback gösterir. CourseHeader göründükten sonra, İÇTEKİ Suspense
    // yalnızca CourseReviews'un yerini kaplar -- sayfanın geri kalanı
    // (CourseHeader dahil) tekrar "loading" durumuna DÖNMEZ.
    <Suspense fallback={<p>Loading page...</p>}>
      <CourseHeader />
      <Suspense fallback={<p>Loading reviews...</p>}>
        <CourseReviews />
      </Suspense>
    </Suspense>
  );
}
