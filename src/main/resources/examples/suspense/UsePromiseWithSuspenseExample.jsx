import { Suspense, use } from "react";

function fetchCourse() {
  return fetch("http://localhost:3000/courses/1").then((response) => response.json());
}

// Her render'da YENİ bir Promise oluşturmamak için, bunu component'in
// DIŞINDA, modül yüklenirken bir kez çağırıyoruz.
const coursePromise = fetchCourse();

function CourseName() {
  // use(), normal hook'ların aksine KOŞULLU olarak da çağrılabilir. Bir
  // Promise verildiğinde, use() Promise HENÜZ çözülmediyse React'e
  // "beklemem gerekiyor" der -- bu, en yakın Suspense'in fallback'ini
  // gösterir; Promise çözülünce gerçek değeri döner.
  const course = use(coursePromise);
  return <p>Course: {course.name}</p>;
}

function UsePromiseWithSuspenseExample() {
  return (
    <Suspense fallback={<p>Loading course...</p>}>
      <CourseName />
    </Suspense>
  );
}
