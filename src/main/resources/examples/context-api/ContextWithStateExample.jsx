import { createContext, useContext, useState } from "react";

const CartContext = createContext(null);

function AddItemButton() {
  const { addItem } = useContext(CartContext);
  return <button onClick={() => addItem("Course")}>Add to Cart</button>;
}

function CartCount() {
  const { items } = useContext(CartContext);
  return <p>Items in cart: {items.length}</p>;
}

function ContextWithStateExample() {
  // Context doesn't only carry a FIXED value -- here we're giving `value`
  // an object: both the state itself (`items`) and the function that
  // UPDATES it (`addItem`). This is the most common way Context is used
  // in real applications.
  const [items, setItems] = useState([]);

  function addItem(item) {
    setItems([...items, item]);
  }

  return (
    <CartContext.Provider value={{ items, addItem }}>
      <AddItemButton />
      <CartCount />
    </CartContext.Provider>
  );
}
