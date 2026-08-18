// Components can be nested -- a component can contain other components,
// which can in turn contain their own components. This is how a large UI
// is built up from small pieces.
function Avatar() {
  return <img src="/avatar.png" alt="Profile picture" />;
}

function UserName() {
  return <span>Jane Smith</span>;
}

function UserProfile() {
  return (
    <div>
      <Avatar />
      <UserName />
    </div>
  );
}

function App() {
  return <UserProfile />;
}

console.log(App());
