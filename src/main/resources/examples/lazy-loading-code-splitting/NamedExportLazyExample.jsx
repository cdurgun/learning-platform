import { lazy, Suspense } from "react";

// lazy(), import() fonksiyonunun DEFAULT export döndürmesini bekler --
// eğer CourseChart yalnızca bir named export ise (`export function
// CourseChart() {}`, `export default` DEĞİL), .then() ile onu bir
// "default" alanına sarmalamamız gerekir.
const CourseChart = lazy(() =>
  import("./CourseChart.jsx").then((module) => ({ default: module.CourseChart })),
);

function NamedExportLazyExample() {
  return (
    <Suspense fallback={<p>Loading chart...</p>}>
      <CourseChart />
    </Suspense>
  );
}
