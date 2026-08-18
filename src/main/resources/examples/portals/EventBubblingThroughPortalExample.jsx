import { useState } from "react";
import { createPortal } from "react-dom";

function Popup() {
  return createPortal(<button>Click me (rendered in document.body)</button>, document.body);
}

function EventBubblingThroughPortalExample() {
  const [clicks, setClicks] = useState(0);

  return (
    // IMPORTANT: Popup is rendered in the DOM OUTSIDE this <div> (in
    // document.body). But when its <button> is clicked, onClick still
    // fires HERE (at its real position in the React tree) -- React
    // "bubbles" events according to its OWN component tree, not the
    // actual DOM tree. This is the most surprising yet most useful
    // feature of Portals.
    <div onClick={() => setClicks(clicks + 1)}>
      <p>Clicks: {clicks}</p>
      <Popup />
    </div>
  );
}
