// Her yerde "props.name", "props.age" yazmak yerine, çoğu React kodunda
// destructuring kullanılır -- fonksiyon parametresinin içinde, ihtiyacın olan
// alanları doğrudan değişken olarak çıkarırsın. İki örnek de AYNI işi yapar,
// ikincisi yalnızca daha kısa ve daha yaygın kullanılan yazım şekli.

// 1) Destructuring OLMADAN:
function UserCardLong(props) {
  return <p>{props.name} -- {props.age} yaşında</p>;
}

// 2) Destructuring İLE (yaygın kullanılan biçim):
function UserCard({ name, age }) {
  return <p>{name} -- {age} yaşında</p>;
}

console.log(UserCardLong({ name: "Ayşe", age: 28 }));
console.log(UserCard({ name: "Ayşe", age: 28 }));
