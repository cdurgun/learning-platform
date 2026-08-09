import java.lang.reflect.Constructor;

class Book {
    private String title;

    Book(String title) {
        this.title = title;
    }

    @Override
    public String toString() {
        return "Book{title='" + title + "'}";
    }
}

class DynamicObjectCreation {
    public static void main(String[] args) throws Exception {
        Class<Book> type = Book.class;

        Constructor<Book> constructor = type.getDeclaredConstructor(String.class);
        Book book = constructor.newInstance("Domain-Driven Design");

        System.out.println(book); // Book{title='Domain-Driven Design'}
    }
}
