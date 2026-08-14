import { useState } from "react";

function ResettingControlledInputExample() {
  const [text, setText] = useState("");

  function handleClear() {
    // Değer state'te olduğu için, input'u temizlemek yalnızca state'i
    // sıfırlamak kadar basit -- gerçek DOM elemanına dokunmaya
    // (useRef ya da event.target.reset() gibi) hiç gerek yok.
    setText("");
  }

  return (
    <div>
      <input
        type="text"
        value={text}
        onChange={(event) => setText(event.target.value)}
      />
      <button onClick={handleClear}>Temizle</button>
    </div>
  );
}
