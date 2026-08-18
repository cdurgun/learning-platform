function StateVsVariableExample() {
  let plainCount = 0; // A plain variable -- NOT state.

  function handleClick() {
    plainCount = plainCount + 1;
    console.log("plainCount is now:", plainCount);
    // The value actually changed, but nothing updates on screen --
    // because React has no idea a plain variable changed.
  }

  return (
    <div>
      <p>The value on screen always stays the same: {plainCount}</p>
      <button onClick={handleClick}>Increment (Screen Won't Change)</button>
    </div>
  );
}
