import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

// toMap(keyMapper, valueMapper) builds a Map from a stream. Its sharpest edge: if two
// elements produce the SAME key, it throws IllegalStateException by default -- there's
// no automatic "last one wins" behavior like some other languages' equivalents.
class ToMapExample {
    public static void main(String[] args) {
        List<String> names = List.of("Ahmet", "Mehmet", "Ayse");

        Map<String, Integer> nameToLength = names.stream()
                .collect(Collectors.toMap(name -> name, String::length));
        System.out.println(nameToLength.get("Ahmet"));

        // Duplicate keys with the two-argument form throw IllegalStateException.
        List<String> withDuplicateFirstLetter = List.of("Ahmet", "Ali");
        try {
            withDuplicateFirstLetter.stream()
                    .collect(Collectors.toMap(name -> name.charAt(0), name -> name));
        } catch (IllegalStateException e) {
            System.out.println("caught: duplicate key");
        }

        // A third argument, a BinaryOperator, resolves the collision explicitly --
        // here, keep the longer name for each starting letter.
        Map<Character, String> longestByFirstLetter = withDuplicateFirstLetter.stream()
                .collect(Collectors.toMap(
                        name -> name.charAt(0),
                        name -> name,
                        (existing, incoming) -> existing.length() >= incoming.length() ? existing : incoming));
        System.out.println(longestByFirstLetter);
    }
}
