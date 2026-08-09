import java.lang.reflect.Field;
import java.lang.reflect.Method;

class Book {
    private String title = "Untitled";

    private boolean isLong() {
        return title.length() > 50;
    }
}

class PrivateAccessExample {
    public static void main(String[] args) throws Exception {
        Book book = new Book();
        Class<Book> type = Book.class;

        Field titleField = type.getDeclaredField("title");
        titleField.setAccessible(true);
        titleField.set(book, "Effective Java");
        System.out.println(titleField.get(book)); // Effective Java

        Method isLong = type.getDeclaredMethod("isLong");
        isLong.setAccessible(true);
        System.out.println(isLong.invoke(book)); // false
    }
}
