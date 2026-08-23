import java.util.List;

public class GenericMethodBasicsExample {

    // A generic method: the <T> right before the return type is the
    // method's OWN type parameter -- declared here because this method
    // lives in an ordinary, non-generic class. Nothing about
    // GenericMethodBasicsExample itself is generic; only this one method is.
    static <T> T firstElement(List<T> list) {
        return list.get(0);
    }

    public static void main(String[] args) {
        List<String> names = List.of("Alice", "Bob");
        String first = firstElement(names); // T is deduced to be String here

        List<Integer> numbers = List.of(10, 20, 30);
        int firstNumber = firstElement(numbers); // same method, T is Integer this time

        System.out.println(first);
        System.out.println(firstNumber);
    }
}
