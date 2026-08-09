import java.lang.reflect.Method;

class Book {
    private String title;

    Book(String title) {
        this.title = title;
    }

    public String getTitle() {
        return title;
    }

    public static String describe() {
        return "A Book represents a published work.";
    }
}

class DynamicMethodInvocation {
    public static void main(String[] args) throws Exception {
        Book book = new Book("Refactoring");
        Class<Book> type = Book.class;

        Method getTitle = type.getMethod("getTitle");
        System.out.println(getTitle.invoke(book)); // Refactoring

        Method describe = type.getMethod("describe");
        System.out.println(describe.invoke(null)); // static method -> no target instance needed
    }
}
