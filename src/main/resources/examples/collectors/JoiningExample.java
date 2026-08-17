import java.util.List;
import java.util.stream.Collectors;

// Collectors.joining() concatenates a stream of Strings -- the collect()-based
// alternative to a manual StringBuilder loop, with three overloads: no arguments
// (plain concatenation), a delimiter, and a delimiter with a prefix and suffix.
class JoiningExample {
    public static void main(String[] args) {
        List<String> names = List.of("Ahmet", "Mehmet", "Ayse");

        String plain = names.stream().collect(Collectors.joining());
        System.out.println(plain);

        String withComma = names.stream().collect(Collectors.joining(", "));
        System.out.println(withComma);

        String withBrackets = names.stream()
                .collect(Collectors.joining(", ", "[", "]"));
        System.out.println(withBrackets);
    }
}
