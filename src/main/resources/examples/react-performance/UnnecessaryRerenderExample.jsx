import { useState } from "react";

function ExpensiveList({ items }) {
  // Bu component'in her render'ı "pahalı" olsun diye console.log koyduk --
  // gerçek bir uygulamada bu, büyük bir liste ya da karmaşık bir hesaplama
  // olabilir.
  console.log("ExpensiveList render edildi");

  return (
    <ul>
      {items.map((item) => (
        <li key={item}>{item}</li>
      ))}
    </ul>
  );
}

const items = ["Java", "React", "Spring Boot"];

function UnnecessaryRerenderExample() {
  const [count, setCount] = useState(0);

  return (
    <div>
      {/* `count` her arttığında, UnnecessaryRerenderExample yeniden render
          olur -- ve React, varsayılan olarak, parent'ı render olan HER
          child'ı da yeniden render eder. ExpensiveList'in props'u (`items`)
          hiç DEĞİŞMEDİĞİ halde, o da gereksiz yere yeniden render olur. */}
      <button onClick={() => setCount(count + 1)}>Count: {count}</button>
      <ExpensiveList items={items} />
    </div>
  );
}
