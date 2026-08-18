function MapRenderListExample() {
  const fruits = ["Apple", "Pear", "Banana"];

  // map() converts each item in an array into a JSX element; the result
  // is again an array (this time made up of JSX elements).
  return (
    <ul>
      {fruits.map((fruit) => (
        <li key={fruit}>{fruit}</li>
      ))}
    </ul>
  );
}
