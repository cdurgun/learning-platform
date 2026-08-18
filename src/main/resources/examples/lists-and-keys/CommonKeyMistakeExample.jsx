function CommonKeyMistakeExample() {
  const items = ["Apple", "Pear", "Banana"];

  return (
    <ul>
      {/* COMMON MISTAKE: using the index as the key. It appears to work
          as long as the list never changes, but when an item is
          added/removed or the order changes, every item's index shifts --
          React may now think the wrong item is "the same item". */}
      {items.map((item, index) => (
        <li key={index}>{item}</li>
      ))}
    </ul>
  );
}
