// "Inheritance" is when, in Object-Oriented Programming, a class inherits
// properties from another class. React components have NO such inheritance --
// instead, "composition" is used: you combine small components by placing
// them INSIDE a larger component.

// Composition -- the way this project (and React) does it:
function Card({ children }) {
  return <div className="card">{children}</div>;
}

function ProfileCard() {
  return (
    <Card>
      <h3>Jane Smith</h3>
      <p>Frontend Developer</p>
    </Card>
  );
}

// You would NOT write inheritance like "class ProfileCard extends Card { ... }"
// in React -- the React team says composition is sufficient and simpler for
// nearly every scenario.

console.log(ProfileCard());
