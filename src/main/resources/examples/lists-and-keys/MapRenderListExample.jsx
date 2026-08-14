function MapRenderListExample() {
  const fruits = ["Elma", "Armut", "Muz"];

  // map(), bir dizideki her elemanı bir JSX elementine çevirir; sonuç
  // yine bir dizi (bu sefer JSX elementlerinden oluşan) olur.
  return (
    <ul>
      {fruits.map((fruit) => (
        <li key={fruit}>{fruit}</li>
      ))}
    </ul>
  );
}
