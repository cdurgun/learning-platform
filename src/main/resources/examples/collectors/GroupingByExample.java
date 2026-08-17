import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

// groupingBy(classifier) groups elements by a key derived from a Function, producing a
// Map<K, List<T>> -- each distinct key maps to a list of every element that produced it.
class GroupingByExample {
    public static void main(String[] args) {
        List<String> names = List.of("Ahmet", "Ali", "Mehmet", "Ayse", "Ata");

        Map<Character, List<String>> byFirstLetter = names.stream()
                .collect(Collectors.groupingBy(name -> name.charAt(0)));
        System.out.println(byFirstLetter);

        Map<Integer, List<String>> byLength = names.stream()
                .collect(Collectors.groupingBy(String::length));
        System.out.println(byLength);
    }
}
