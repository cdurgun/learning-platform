function EventHandlerFunctionExample() {
  function sayHello() {
    console.log("Merhaba!");
  }

  return (
    <div>
      {/* DOĞRU: fonksiyonun kendisini veriyoruz, çağırmıyoruz. */}
      <button onClick={sayHello}>İsimli Fonksiyon</button>

      {/* Inline (satır içi) bir fonksiyon da yazabilirsin. */}
      <button onClick={() => console.log("Selam!")}>Inline Fonksiyon</button>

      {/* YANLIŞ: sayHello() yazarsan, fonksiyon component render olur
          olmaz hemen çalışır -- tıklamayı beklemez. */}
      {/* <button onClick={sayHello()}>Yanlış Kullanım</button> */}
    </div>
  );
}
