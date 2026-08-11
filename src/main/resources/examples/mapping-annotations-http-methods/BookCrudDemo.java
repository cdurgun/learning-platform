import org.springframework.http.ResponseEntity;

class BookCrudDemo {
    public static void main(String[] args) {
        BookCrudController controller = new BookCrudController();

        ResponseEntity<Long> created = controller.create("Effective Java");
        System.out.println(created.getStatusCode() + " id=" + created.getBody());
        // 201 CREATED id=1

        System.out.println(controller.list());
        // [Effective Java]

        System.out.println(controller.getOne(1L).getBody());
        // Effective Java

        controller.replace(1L, "Effective Java (3rd Edition)");
        System.out.println(controller.getOne(1L).getBody());
        // Effective Java (3rd Edition)

        System.out.println(controller.delete(1L).getStatusCode());
        // 204 NO_CONTENT
        System.out.println(controller.getOne(1L).getStatusCode());
        // 404 NOT_FOUND
    }
}
