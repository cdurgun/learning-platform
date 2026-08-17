import java.util.List;

// filter() keeps only elements matching a Predicate -- the stream may get SHORTER.
// map() transforms each element with a Function -- the stream stays the same length,
// but element type/value can change. Chaining them is the core Stream idiom.
class FilterMapExample {
    public static void main(String[] args) {
        List<String> names = List.of("Ahmet", "Mehmet", "Ayse", "Ali");

        List<String> result = names.stream()
                .filter(name -> name.startsWith("A"))
                .map(String::toUpperCase)
                .toList();
        System.out.println(result);

        // Order matters for performance (not correctness here): filtering before an
        // expensive map() means map() runs on fewer elements.
        List<Integer> lengths = names.stream()
                .filter(name -> name.length() > 4)
                .map(String::length)
                .toList();
        System.out.println(lengths);
    }
}
