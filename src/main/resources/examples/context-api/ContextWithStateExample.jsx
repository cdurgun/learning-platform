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
  // Context yalnızca SABİT bir değer taşımaz -- burada `value`'ya bir
  // nesne veriyoruz: hem state'in kendisi (`items`) hem de onu
  // GÜNCELLEYEN fonksiyon (`addItem`). Bu, gerçek uygulamalarda en sık
  // görülen Context kullanımı.
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
