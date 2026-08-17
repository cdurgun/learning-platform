import java.util.List;
import java.util.Optional;

// findFirst()/findAny() return Optional<T> -- the FIRST element (in encounter order) or
// ANY element satisfying the pipeline so far; for a sequential stream both behave the
// same, findAny() only differs (and can be faster) for parallel streams.
// anyMatch()/allMatch()/noneMatch() ask a yes/no question about the whole stream, using
// a Predicate, and return a plain boolean.
class FindMatchExample {
    public static void main(String[] args) {
        List<String> names = List.of("Ahmet", "Mehmet", "Ayse", "Ali");

        Optional<String> firstLong = names.stream()
                .filter(n -> n.length() > 4)
                .findFirst();
        System.out.println(firstLong.orElse("none"));

        Optional<String> anyStartingWithA = names.stream()
                .filter(n -> n.startsWith("A"))
                .findAny();
        System.out.println(anyStartingWithA.orElse("none"));

        boolean hasShortName = names.stream().anyMatch(n -> n.length() <= 3);
        System.out.println(hasShortName);

        boolean allStartWithCapital = names.stream().allMatch(n -> Character.isUpperCase(n.charAt(0)));
        System.out.println(allStartWithCapital);

        boolean noneAreEmpty = names.stream().noneMatch(String::isEmpty);
        System.out.println(noneAreEmpty);
    }
}
