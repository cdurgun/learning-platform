// Gerçek uygulamalarda, fetch çağrılarını her component'in içine dağıtmak
// yerine ayrı bir dosyada (örneğin api.js) toplamak yaygındır -- bu, tüm
// istekleri TEK bir yerde tutar, `BASE_URL`'i tek bir yerde değiştirmeyi
// sağlar. Bu örnek, o dosyanın İÇERİĞİNİ gösteriyor (normalde ayrı bir
// dosya olurdu, component'ler bu fonksiyonları import ederdi).

const BASE_URL = "http://localhost:3000";

async function getCourses() {
  const response = await fetch(`${BASE_URL}/courses`);
  if (!response.ok) {
    throw new Error("Failed to load courses");
  }
  return response.json();
}

async function createCourse(course) {
  const response = await fetch(`${BASE_URL}/courses`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(course),
  });
  return response.json();
}

async function deleteCourse(courseId) {
  await fetch(`${BASE_URL}/courses/${courseId}`, { method: "DELETE" });
}

function ApiModuleExample() {
  return (
    <p>
      This represents an api.js module: getCourses(), createCourse() and
      deleteCourse() wrap the raw fetch calls in one place.
    </p>
  );
}
