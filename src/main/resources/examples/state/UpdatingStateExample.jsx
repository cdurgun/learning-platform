import { useState } from "react";

function UpdatingStateExample() {
  const [count, setCount] = useState(0);

  function increment() {
    setCount(count + 1);
  }

  function reset() {
    setCount(0);
  }

  return (
    <div>
      <p>Sayaç: {count}</p>
      <button onClick={increment}>+1</button>
      <button onClick={reset}>Sıfırla</button>
    </div>
  );
}
