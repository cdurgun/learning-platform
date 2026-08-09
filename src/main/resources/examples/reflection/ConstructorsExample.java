import java.lang.reflect.Constructor;
import java.util.Arrays;

class Book {
    private String title;
    private String author;
    private int pages;

    Book() {
        this("Untitled", "Unknown", 0);
    }

    Book(String title, String author, int pages) {
        this.title = title;
        this.author = author;
        this.pages = pages;
    }
}

class ConstructorsExample {
    public static void main(String[] args) {
        Class<Book> type = Book.class;

        for (Constructor<?> c : type.getDeclaredConstructors()) {
            System.out.println(c.getParameterCount() + " parameter(s): "
                    + Arrays.toString(c.getParameterTypes()));
        }
        // 0 parameter(s): []
        // 3 parameter(s): [class java.lang.String, class java.lang.String, int]
    }
}
