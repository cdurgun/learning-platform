import { memo, useState } from "react";

// memo() wraps a component in a "memoized" version -- BEFORE re-rendering,
// React checks whether the props are the SAME as last time; if they are,
// it SKIPS the render.
const ExpensiveList = memo(function ExpensiveList({ items }) {
  console.log("ExpensiveList rendered");

  return (
    <ul>
      {items.map((item) => (
        <li key={item}>{item}</li>
      ))}
    </ul>
  );
});

// We define `items` OUTSIDE the component -- if we put it inside, a NEW
// array would be created on every render, its reference would change, and
// memo would never be able to skip the render (see the next lesson,
// "ReactMemoWithCallbackExample").
const items = ["Java", "React", "Spring Boot"];

function ReactMemoExample() {
  const [count, setCount] = useState(0);

  return (
    <div>
      {/* When `count` increases, ReactMemoExample re-renders, but since the
          CONTENTS of `items` stayed the same (same array elements), memo
          now SKIPS re-rendering ExpensiveList. */}
      <button onClick={() => setCount(count + 1)}>Count: {count}</button>
      <ExpensiveList items={items} />
    </div>
  );
}
