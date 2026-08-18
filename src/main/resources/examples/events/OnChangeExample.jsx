function OnChangeExample() {
  function handleChange(event) {
    console.log("Typed value:", event.target.value);
  }

  return <input type="text" onChange={handleChange} placeholder="Type something..." />;
}
