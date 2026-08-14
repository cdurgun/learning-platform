function OnChangeExample() {
  function handleChange(event) {
    console.log("Yazılan değer:", event.target.value);
  }

  return <input type="text" onChange={handleChange} placeholder="Bir şey yaz..." />;
}
