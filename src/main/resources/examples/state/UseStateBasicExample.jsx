import { useState } from "react";

function UseStateBasicExample() {
  // useState(0), state'i 0 başlangıç değeriyle kurar.
  // count: mevcut değeri okumak için. setCount: değeri güncellemek için.
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>Sayaç: {count}</p>
      <button onClick={() => setCount(count + 1)}>Artır</button>
    </div>
  );
}
