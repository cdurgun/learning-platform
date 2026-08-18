function WhyKeysMatterExample() {
  const tasks = [
    { id: 1, text: "Buy milk" },
    { id: 2, text: "Buy bread" },
  ];

  // The key tells React "which item from the previous render this list
  // item is the same as". When an item is added/removed or the order
  // changes, React uses this to update the correct item -- without a key
  // (or with the wrong key), React might update the wrong item, causing
  // unexpected visual bugs (e.g. an input shifting to the wrong row).
  return (
    <ul>
      {tasks.map((task) => (
        <li key={task.id}>{task.text}</li>
      ))}
    </ul>
  );
}
