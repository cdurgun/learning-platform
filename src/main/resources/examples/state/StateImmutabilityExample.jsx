import { useState } from "react";

function StateImmutabilityExample() {
  const [user, setUser] = useState({ name: "Ayşe", age: 25 });

  function haveBirthday() {
    // YANLIŞ: mevcut nesneyi doğrudan değiştirmek (mutate etmek).
    // React bu değişikliği fark etmeyebilir, ekran güncellenmeyebilir.
    // user.age = user.age + 1;
    // setUser(user);

    // DOĞRU: spread (...) ile eski değerleri kopyalayan YENİ bir nesne
    // oluşturup onu state'e veriyoruz.
    setUser({ ...user, age: user.age + 1 });
  }

  return (
    <div>
      <p>
        {user.name}, {user.age} yaşında.
      </p>
      <button onClick={haveBirthday}>Doğum Günü</button>
    </div>
  );
}
