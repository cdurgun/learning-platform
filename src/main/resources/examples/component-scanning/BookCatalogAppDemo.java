import org.springframework.context.annotation.AnnotationConfigApplicationContext;

class BookCatalogAppDemo {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);

        BookController controller = context.getBean(BookController.class);
        controller.printCatalog();
        // - Java 21 Book
        // - Spring Boot Book

        // BookRepository is a singleton, so this change is visible to every
        // later call -- exactly the "Bean Scope: Singleton (Default)"
        // behavior from the Spring IoC Container lesson.
        context.getBean(BookService.class).addBook("Reflection Book");
        controller.printCatalog();
        // - Java 21 Book
        // - Spring Boot Book
        // - Reflection Book

        context.close();
    }
}
