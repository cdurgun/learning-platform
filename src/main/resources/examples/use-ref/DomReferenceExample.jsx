import { useRef } from "react";

function DomReferenceExample() {
  const inputRef = useRef(null);

  function focusInput() {
    // inputRef.current, gerçek DOM elementinin kendisi -- input'un
    // sahip olduğu tarayıcı metotlarını (focus() gibi) doğrudan çağırabiliriz.
    inputRef.current.focus();
  }

  return (
    <div>
      <input ref={inputRef} type="text" placeholder="Butona basınca odaklanır" />
      <button onClick={focusInput}>Input'a Odaklan</button>
    </div>
  );
}
