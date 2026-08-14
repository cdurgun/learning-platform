import { useState } from "react";

function useCounter(initialValue = 0) {
  const [count, setCount] = useState(initialValue);
  return {
    count,
    increment: () => setCount((prev) => prev + 1),
  };
}

function ReusingCustomHookExample() {
  // Aynı hook'u iki kez çağırıyoruz -- her çağrı kendi BAĞIMSIZ state'ine sahip.
  const apples = useCounter(0);
  const oranges = useCounter(10);

  return (
    <div>
      <p>Elma: {apples.count}</p>
      <button onClick={apples.increment}>Elma Ekle</button>

      <p>Portakal: {oranges.count}</p>
      <button onClick={oranges.increment}>Portakal Ekle</button>
    </div>
  );
}
