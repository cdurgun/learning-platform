import { useState } from "react";
import { createPortal } from "react-dom";

function Modal({ onClose, children }) {
  // A modal is the most common use case for a Portal -- the modal's CSS
  // (position: fixed, z-index) makes it appear ON TOP of the rest of the
  // page, but its actual DOM position (e.g. "inside a card") can
  // sometimes block that (e.g. overflow: hidden). The Portal ELIMINATES
  // this problem by rendering the modal directly into `document.body`.
  return createPortal(
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content" onClick={(event) => event.stopPropagation()}>
        {children}
        <button onClick={onClose}>Close</button>
      </div>
    </div>,
    document.body,
  );
}

function ModalWithPortalExample() {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <div>
      <button onClick={() => setIsOpen(true)}>Open Modal</button>
      {isOpen && (
        <Modal onClose={() => setIsOpen(false)}>
          <p>This is a modal, rendered outside the normal DOM tree.</p>
        </Modal>
      )}
    </div>
  );
}
