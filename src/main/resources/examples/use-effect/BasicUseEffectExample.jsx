import { useState, useEffect } from "react";

function BasicUseEffectExample() {
  const [count, setCount] = useState(0);

  // A SIDE EFFECT: something a component does outside of its own render
  // output (JSX) -- here we're changing the browser's tab title.
  useEffect(() => {
    document.title = `Count: ${count}`;
  });

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  );
}
