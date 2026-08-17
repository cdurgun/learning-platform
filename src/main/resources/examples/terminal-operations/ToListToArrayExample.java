import java.util.List;

// toList() (added in Java 16) is a convenience shorthand for the far more general
// collect(Collectors.toList()) -- covered fully in the next lesson, Collectors. It
// returns an UNMODIFIABLE List, unlike collect(Collectors.toList())'s mutable one.
// toArray() converts a stream into an array instead of a List.
class ToListToArrayExample {
    public static void main(String[] args) {
        List<String> names = List.of("Ahmet", "Mehmet", "Ayse");

        List<String> upper = names.stream().map(String::toUpperCase).toList();
        System.out.println(upper);

        try {
            upper.add("EXTRA");
        } catch (UnsupportedOperationException e) {
            System.out.println("caught: toList() result is unmodifiable");
        }

        String[] asArray = names.stream().toArray(String[]::new);
        System.out.println(asArray.length + " " + asArray[0]);
    }
}
