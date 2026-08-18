import { useState } from "react";

function ExpensiveList({ items }) {
  // We added this console.log to make every render of this component
  // "expensive" -- in a real app this could be a large list or a complex
  // calculation.
  console.log("ExpensiveList rendered");

  return (
    <ul>
      {items.map((item) => (
        <li key={item}>{item}</li>
      ))}
    </ul>
  );
}

const items = ["Java", "React", "Spring Boot"];

function UnnecessaryRerenderExample() {
  const [count, setCount] = useState(0);

  return (
    <div>
      {/* Every time `count` increases, UnnecessaryRerenderExample
          re-renders -- and by default, React also re-renders EVERY child
          whose parent re-rendered. Even though ExpensiveList's props
          (`items`) never CHANGE, it still re-renders unnecessarily. */}
      <button onClick={() => setCount(count + 1)}>Count: {count}</button>
      <ExpensiveList items={items} />
    </div>
  );
}
