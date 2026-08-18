import { useState, useRef } from "react";

function PersistentValueExample() {
  const [count, setCount] = useState(0);
  const renderCount = useRef(0);

  renderCount.current = renderCount.current + 1;
  // renderCount.current changes, but this does NOT TRIGGER A RE-RENDER --
  // it only shows the up-to-date value on the next render.

  return (
    <div>
      <p>Count: {count}</p>
      <p>This component has rendered {renderCount.current} times so far.</p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  );
}
