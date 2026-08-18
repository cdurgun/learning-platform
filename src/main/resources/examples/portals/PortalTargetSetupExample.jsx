import { createPortal } from "react-dom";

function Tooltip({ text }) {
  // Instead of document.body, it's more common to use a target set aside
  // specifically in index.html -- for example <div id="tooltip-root"></div>,
  // added as a SIBLING to the app's #root. This makes it easier for the
  // portal content to manage its own styles/position.
  const target = document.getElementById("tooltip-root");

  if (!target) {
    return null;
  }

  return createPortal(<span className="tooltip">{text}</span>, target);
}

function PortalTargetSetupExample() {
  return (
    <div>
      <p>Hover for more info</p>
      <Tooltip text="This tooltip lives in its own DOM node." />
    </div>
  );
}
