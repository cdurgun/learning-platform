function CommonKeyMistakeExample() {
  const items = ["Elma", "Armut", "Muz"];

  return (
    <ul>
      {/* YAYGIN HATA: index'i key olarak kullanmak. Liste hiç değişmediği
          sürece çalışıyor gibi görünür, ama bir eleman eklenip/silindiğinde
          ya da sıralama değiştiğinde her elemanın index'i kayar -- React
          artık yanlış elemanı "aynı eleman" sanabilir. */}
      {items.map((item, index) => (
        <li key={index}>{item}</li>
      ))}
    </ul>
  );
}
