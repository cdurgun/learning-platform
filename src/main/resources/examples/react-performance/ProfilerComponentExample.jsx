import { Profiler, useState } from "react";

function onRenderCallback(id, phase, actualDuration) {
  // React calls this function after every render -- `id` is the name we
  // gave the Profiler; `phase` is whether it was a "mount" (initial render)
  // or an "update" (re-render); `actualDuration` is how many milliseconds
  // the render took.
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
      {/* React's built-in <Profiler> component MEASURES the render time of
          the tree it wraps -- this is the mechanism behind the "Profiler"
          tab in React DevTools. In real apps it's usually added
          temporarily while INVESTIGATING a performance issue, not left in
          as permanent code. */}
      <Profiler id="CourseList" onRender={onRenderCallback}>
        <CourseList items={items} />
      </Profiler>
    </div>
  );
}
