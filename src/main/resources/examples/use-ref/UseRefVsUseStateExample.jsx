import { useState, useRef } from "react";

function UseRefVsUseStateExample() {
  const [stateValue, setStateValue] = useState(0);
  const refValue = useRef(0);

  function incrementState() {
    setStateValue(stateValue + 1); // Ekranı günceller (re-render tetikler).
  }

  function incrementRef() {
    refValue.current = refValue.current + 1;
    console.log("refValue.current:", refValue.current);
    // Değer gerçekten değişti, ama ekran GÜNCELLENMEZ -- çünkü ref
    // değişikliği bir re-render tetiklemez.
  }

  return (
    <div>
      <p>State: {stateValue}</p>
      <button onClick={incrementState}>State'i Artır</button>
      <button onClick={incrementRef}>Ref'i Artır (Console'a Bak)</button>
    </div>
  );
}
