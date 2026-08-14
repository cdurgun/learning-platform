function AndOperatorConditionalExample({ hasNewMessage }) {
  // && işleci: sol taraf "truthy" ise sağ tarafı render eder, "falsy"
  // ise (false, 0, "", null, undefined) hiçbir şey render etmez.
  // Ternary'nin "else" kısmı olmadığı, yani "ya bunu göster ya da
  // hiçbir şey gösterme" durumunda kullanışlı.
  return (
    <div>
      <p>Gelen Kutusu</p>
      {hasNewMessage && <p>Yeni bir mesajın var!</p>}
    </div>
  );
}
