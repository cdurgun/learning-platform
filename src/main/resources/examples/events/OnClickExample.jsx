function OnClickExample() {
  function handleClick() {
    console.log("Button clicked!");
  }

  return <button onClick={handleClick}>Click</button>;
}
