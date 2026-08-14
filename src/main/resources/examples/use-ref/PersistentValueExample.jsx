import { useState, useRef } from "react";

function PersistentValueExample() {
  const [count, setCount] = useState(0);
  const renderCount = useRef(0);

  renderCount.current = renderCount.current + 1;
  // renderCount.current değişiyor, ama bu bir RE-RENDER TETİKLEMEZ --
  // yalnızca bir sonraki render'da güncel değeri gösterir.

  return (
    <div>
      <p>Sayaç: {count}</p>
      <p>Bu component şu ana kadar {renderCount.current} kez render oldu.</p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  );
}
