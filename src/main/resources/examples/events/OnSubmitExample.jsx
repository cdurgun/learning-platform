function OnSubmitExample() {
  function handleSubmit(event) {
    // preventDefault olmadan, tarayıcı formu göndermeye çalışır ve
    // sayfa yeniden yüklenir -- React uygulamalarında bunu istemeyiz.
    event.preventDefault();
    console.log("Form gönderildi!");
  }

  return (
    <form onSubmit={handleSubmit}>
      <button type="submit">Gönder</button>
    </form>
  );
}
