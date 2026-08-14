function StateVsVariableExample() {
  let plainCount = 0; // Normal bir değişken -- state DEĞİL.

  function handleClick() {
    plainCount = plainCount + 1;
    console.log("plainCount şimdi:", plainCount);
    // Değer aslında değişti, ama ekranda hiçbir şey güncellenmez --
    // çünkü React, normal bir değişkenin değiştiğini bilmiyor.
  }

  return (
    <div>
      <p>Ekrandaki değer hep aynı kalır: {plainCount}</p>
      <button onClick={handleClick}>Artır (Ekran Değişmez)</button>
    </div>
  );
}
