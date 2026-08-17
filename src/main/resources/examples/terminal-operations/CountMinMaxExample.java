import java.util.Comparator;
import java.util.List;
import java.util.Optional;

// count() returns how many elements reached the terminal operation, as a long.
// min()/max() need a Comparator to know what "smallest"/"largest" means -- there's no
// parameterless overload, since the stream's element type might not be Comparable.
// Both return Optional<T>, for the same reason as reduce(accumulator): an empty stream
// has no minimum or maximum.
class CountMinMaxExample {
    public static void main(String[] args) {
        List<String> names = List.of("Ahmet", "Mehmet", "Ayse", "Ali");

        long count = names.stream().filter(n -> n.length() > 3).count();
        System.out.println(count);

        Optional<String> shortest = names.stream().min(Comparator.comparingInt(String::length));
        System.out.println(shortest.orElse("none"));

        Optional<String> longest = names.stream().max(Comparator.comparingInt(String::length));
        System.out.println(longest.orElse("none"));

        // Comparator.naturalOrder() uses the type's own Comparable -- alphabetical here.
        Optional<String> firstAlphabetically = names.stream().min(Comparator.naturalOrder());
        System.out.println(firstAlphabetically.orElse("none"));
    }
}
