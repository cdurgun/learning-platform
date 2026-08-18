// Attributes in JSX are very similar to HTML, but there are a few differences:
// 1) "className" is used instead of "class" (class has a separate meaning in JavaScript).
// 2) Attribute values can also be a JavaScript variable using { }.
const userName = "ayse";

const avatar = (
  <img className="avatar" src={`/images/${userName}.png`} alt="User avatar" />
);

// If the tag itself doesn't close (e.g. <img>, <input>, <br>), it MUST be
// "self-closing" in JSX -- a / is added at the end.
const divider = <hr />;

console.log(avatar, divider);
