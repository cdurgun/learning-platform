import { useRef } from "react";

function DomReferenceExample() {
  const inputRef = useRef(null);

  function focusInput() {
    // inputRef.current is the actual DOM element itself -- we can call the
    // browser methods the input has (like focus()) directly.
    inputRef.current.focus();
  }

  return (
    <div>
      <input ref={inputRef} type="text" placeholder="Focuses when the button is clicked" />
      <button onClick={focusInput}>Focus Input</button>
    </div>
  );
}
