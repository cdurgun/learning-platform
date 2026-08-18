function PutAndDeleteExample({ courseId }) {
  function handleRename(newName) {
    // PUT COMPLETELY updates an existing record -- we send the new value,
    // and the server replaces the record with it.
    fetch(`/api/courses/${courseId}`, {
      method: "PUT",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ name: newName }),
    });
  }

  function handleDelete() {
    // DELETE usually specifies which record to delete via the id in the
    // URL, without sending a body.
    fetch(`/api/courses/${courseId}`, { method: "DELETE" });
  }

  return (
    <div>
      <button onClick={() => handleRename("Updated Name")}>Rename</button>
      <button onClick={handleDelete}>Delete</button>
    </div>
  );
}
