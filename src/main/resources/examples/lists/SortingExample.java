import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class SortingExample {
    record Person(String name, int age) {
    }

    public static void main(String[] args) {
        List<Integer> numbers = new ArrayList<>(List.of(5, 3, 8, 1, 9, 2));

        // List.sort(): sorts in place; Comparator.naturalOrder() for natural ordering
        numbers.sort(Comparator.naturalOrder());
        System.out.println("Natural order: " + numbers);

        numbers.sort(Comparator.reverseOrder());
        System.out.println("Reversed order: " + numbers);

        // Collections.sort(): the old way, predating List.sort() (pre-Java 8), still works
        List<String> words = new ArrayList<>(List.of("banana", "apple", "kiwi", "pear"));
        Collections.sort(words);
        System.out.println("Collections.sort(): " + words);

        // Comparator.comparing() + thenComparing(): sorting objects by a field
        List<Person> people = new ArrayList<>(List.of(
                new Person("Alice", 30),
                new Person("Bob", 25),
                new Person("Alice", 22)
        ));

        people.sort(Comparator.comparing(Person::name).thenComparing(Person::age));
        System.out.println("By name, then age: " + people);

        people.sort(Comparator.comparingInt(Person::age).reversed());
        System.out.println("By age, descending: " + people);
    }
}
