// JSX has a few simple but strict rules:

// 1) A JSX block must have a SINGLE root element.
// This does NOT WORK: <h1>Title</h1><p>Text</p>  (two sibling elements, no single root)
// Instead, wrap it with a <div> (or with <> </> as below):
const withDiv = (
  <div>
    <h1>Title</h1>
    <p>Text</p>
  </div>
);

// <> </> ("Fragment") does the same job without adding an extra <div> --
// a wrapper invisible to the DOM, existing only to satisfy the JSX rule.
const withFragment = (
  <>
    <h1>Title</h1>
    <p>Text</p>
  </>
);

// 2) Attribute names are written in camelCase: "onClick" not "onclick",
// "tabIndex" not "tabindex".

// 3) "className" is used because "class" is a keyword in JavaScript.

console.log(withDiv, withFragment);
