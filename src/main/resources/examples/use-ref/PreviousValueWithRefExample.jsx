import { useState, useEffect, useRef } from "react";

function PreviousValueWithRefExample() {
  const [count, setCount] = useState(0);
  const previousCountRef = useRef(undefined);

  useEffect(() => {
    // AFTER every render, we save the current value into the ref -- so we
    // can read it as the "previous value" on the next render. We use a ref
    // instead of state here because we want to record this without
    // triggering another render.
    previousCountRef.current = count;
  });

  return (
    <div>
      <p>
        Current: {count}, Previous: {previousCountRef.current}
      </p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  );
}
