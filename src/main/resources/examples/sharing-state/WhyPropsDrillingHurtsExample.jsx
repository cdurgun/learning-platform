function Level1({ user }) {
  return <Level2 user={user} />;
}

function Level2({ user }) {
  return <Level3 user={user} />;
}

function Level3({ user }) {
  return <Level4 user={user} />;
}

function Level4({ user }) {
  return <p>Logged in as {user}</p>;
}

function WhyPropsDrillingHurtsExample() {
  // NONE of Level1, Level2, or Level3 use `user` -- they just PASS IT
  // ALONG to the next level. Only Level4, at the very bottom, actually
  // uses it. As the tree gets deeper (or new props are added at every
  // level) this becomes tedious to write and error-prone -- in the next
  // lesson (Context API) we'll see an approach that solves this.
  return <Level1 user="Ada" />;
}
