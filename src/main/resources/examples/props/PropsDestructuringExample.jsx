// Instead of writing "props.name", "props.age" everywhere, most React code
// uses destructuring -- inside the function parameter, you pull the fields
// you need out directly as variables. Both examples do the SAME thing,
// the second one is just shorter and the more commonly used style.

// 1) WITHOUT destructuring:
function UserCardLong(props) {
  return <p>{props.name} -- {props.age} years old</p>;
}

// 2) WITH destructuring (the commonly used style):
function UserCard({ name, age }) {
  return <p>{name} -- {age} years old</p>;
}

console.log(UserCardLong({ name: "Emma", age: 28 }));
console.log(UserCard({ name: "Emma", age: 28 }));
