import { Profiler, useState } from "react";

function onRenderCallback(id, phase, actualDuration) {
  // React, her render'dan sonra bu fonksiyonu çağırır -- `id`, Profiler'a
  // verdiğimiz isim; `phase`, "mount" (ilk render) mı yoksa "update" (yeniden
  // render) mı olduğu; `actualDuration`, render'ın kaç milisaniye sürdüğü.
  console.log(`${id} (${phase}) took ${actualDuration.toFixed(2)}ms`);
}

function CourseList({ items }) {
  return (
    <ul>
      {items.map((item) => (
        <li key={item}>{item}</li>
      ))}
    </ul>
  );
}

function ProfilerComponentExample() {
  const [count, setCount] = useState(0);
  const items = ["Java", "React", "Spring Boot"];

  return (
    <div>
      <button onClick={() => setCount(count + 1)}>Count: {count}</button>
      {/* React'in yerleşik <Profiler> component'i, sarmaladığı ağacın render
          süresini ÖLÇER -- React DevTools'taki "Profiler" sekmesinin
          arkasındaki mekanizma budur. Gerçek uygulamalarda genellikle
          kalıcı kod olarak değil, performans sorununu ARAŞTIRIRKEN geçici
          olarak eklenir. */}
      <Profiler id="CourseList" onRender={onRenderCallback}>
        <CourseList items={items} />
      </Profiler>
    </div>
  );
}
