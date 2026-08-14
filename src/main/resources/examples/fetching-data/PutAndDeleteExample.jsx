function PutAndDeleteExample({ courseId }) {
  function handleRename(newName) {
    // PUT, var olan bir kaydı TAMAMEN günceller -- yeni değeri gönderiyoruz,
    // sunucu ilgili kaydı bununla değiştiriyor.
    fetch(`/api/courses/${courseId}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name: newName }),
    });
  }

  function handleDelete() {
    // DELETE, genellikle bir body göndermeden, yalnızca URL'deki id ile
    // hangi kaydın silineceğini belirtir.
    fetch(`/api/courses/${courseId}`, { method: "DELETE" });
  }

  return (
    <div>
      <button onClick={() => handleRename("Updated Name")}>Rename</button>
      <button onClick={handleDelete}>Delete</button>
    </div>
  );
}
