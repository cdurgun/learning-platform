import { useState } from "react";
import { createPortal } from "react-dom";

function Modal({ onClose, children }) {
  // Bir modal, Portal'ın en yaygın kullanım alanıdır -- modal'ın CSS'i
  // (position: fixed, z-index) sayfanın geri kalanının ÜSTÜNDE görünmesini
  // sağlar, ama gerçek DOM konumu ("bir kartın içinde" gibi) bunu bazen
  // engelleyebilir (overflow: hidden gibi). Portal, modal'ı doğrudan
  // `document.body`'ye render ederek bu sorunu ORTADAN KALDIRIR.
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
