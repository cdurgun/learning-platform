function OnClickExample() {
  function handleClick() {
    console.log("Butona tıklandı!");
  }

  return <button onClick={handleClick}>Tıkla</button>;
}
