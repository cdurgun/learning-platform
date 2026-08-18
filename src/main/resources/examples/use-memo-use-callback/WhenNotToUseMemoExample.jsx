import { useState, useMemo } from "react";

function WhenNotToUseMemoExample() {
  const [count, setCount] = useState(0);

  // UNNECESSARY: This addition is already very fast -- useMemo's own
  // overhead (doing the comparison, keeping the result in memory) can be
  // more expensive than what it saves.
  // const doubled = useMemo(() => count * 2, [count]);

  // BETTER: useMemo isn't needed for simple, fast calculations.
  const doubled = count * 2;

  return (
    <div>
      <p>
        {count} x 2 = {doubled}
      </p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  );
}
