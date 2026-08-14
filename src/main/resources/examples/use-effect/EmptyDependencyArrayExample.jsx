import { useState, useEffect } from "react";

function EmptyDependencyArrayExample() {
  const [count, setCount] = useState(0);

  useEffect(() => {
    console.log("Component ilk kez ekrana geldi (mount oldu).");
  }, []); // Boş dependency array: yalnızca İLK render'dan sonra bir kez çalışır.

  return (
    <div>
      <p>Sayaç: {count}</p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  );
}
