import { createPortal } from "react-dom";

function BasicPortalExample() {
  // createPortal(child, container) renders `child` into a different DOM
  // node (`container`) INSTEAD OF its place in the normal React tree --
  // here, `document.body` itself. In the component tree (in React
  // DevTools) it still appears INSIDE BasicPortalExample, but in the
  // actual DOM it's in a completely different location.
  return createPortal(<p className="tooltip">I'm rendered directly on body!</p>, document.body);
}
