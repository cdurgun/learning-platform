import { useState } from "react";

// Özel bir hook, "use" ile başlayan NORMAL bir JavaScript fonksiyonudur --
// içinde React'in kendi hook'larını (useState, useEffect gibi) çağırabilir.
function useCounter(initialValue = 0) {
  const [count, setCount] = useState(initialValue);

  function increment() {
    setCount((prev) => prev + 1);
  }

  function decrement() {
    setCount((prev) => prev - 1);
  }

  return { count, increment, decrement };
}

function CustomHookNamingExample() {
  const { count, increment, decrement } = useCounter(0);

  return (
    <div>
      <p>Sayaç: {count}</p>
      <button onClick={increment}>+1</button>
      <button onClick={decrement}>-1</button>
    </div>
  );
}
