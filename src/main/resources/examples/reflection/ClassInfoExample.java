import java.lang.reflect.Modifier;

class Book {
    private String title;
    private String author;
    private int pages;

    Book(String title, String author, int pages) {
        this.title = title;
        this.author = author;
        this.pages = pages;
    }
}

class ClassInfoExample {
    public static void main(String[] args) {
        Class<Book> type = Book.class;

        System.out.println(type.getName());        // Book
        System.out.println(type.getSimpleName());   // Book
        System.out.println(type.getPackageName());  // (empty string — default package)
        System.out.println(type.isInterface());     // false
        System.out.println(type.isRecord());        // false
        System.out.println(Modifier.isPublic(type.getModifiers())); // false — package-private
    }
}
