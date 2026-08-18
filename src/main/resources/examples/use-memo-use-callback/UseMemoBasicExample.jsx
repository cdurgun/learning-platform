import { useState, useMemo } from "react";

function slowSquare(n) {
  // Deliberately a SLOW computation -- to simulate a real "expensive
  // calculation".
  let result = 0;
  for (let i = 0; i < 100000000; i++) {
    result = n * n;
  }
  return result;
}

function UseMemoBasicExample() {
  const [number, setNumber] = useState(5);
  const [theme, setTheme] = useState("light");

  // useMemo does NOT re-run slowSquare as long as `number` hasn't changed --
  // it keeps the previous result in memory (memoizes it) and returns that.
  const squared = useMemo(() => slowSquare(number), [number]);

  return (
    <div>
      <p>
        Square of {number}: {squared}
      </p>
      <button onClick={() => setNumber(number + 1)}>Increase Number</button>
      <button onClick={() => setTheme(theme === "light" ? "dark" : "light")}>
        Toggle Theme ({theme})
      </button>
    </div>
  );
}
