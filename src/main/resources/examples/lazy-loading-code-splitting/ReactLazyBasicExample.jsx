import { lazy, Suspense, useState } from "react";

// lazy(), component'in KODUNU normal bir import yerine dinamik bir
// import() ile yükler -- bu dosya, uygulamanın ilk yüklenen paketine
// (bundle) DAHİL EDİLMEZ, yalnızca gerçekten gerektiğinde ayrı bir dosya
// olarak indirilir. Bu, "code splitting" dediğimiz şey.
const CourseDetails = lazy(() => import("./CourseDetails.jsx"));

function ReactLazyBasicExample() {
  const [showDetails, setShowDetails] = useState(false);

  return (
    <div>
      <button onClick={() => setShowDetails(true)}>Show Details</button>
      {showDetails && (
        // Suspense, lazy component'in kodu YÜKLENIRKEN gösterilecek bir
        // fallback UI belirtir -- kod indirilene kadar `fallback`
        // gösterilir, indirilince gerçek component render edilir.
        <Suspense fallback={<p>Loading...</p>}>
          <CourseDetails />
        </Suspense>
      )}
    </div>
  );
}
