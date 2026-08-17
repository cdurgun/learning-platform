import java.util.List;

// forEach(Consumer<T>) runs a side effect on every element and returns void -- it's the
// terminal operation equivalent of a for-each loop. Since it returns nothing, it can only
// end a pipeline, never continue one.
class ForEachExample {
    public static void main(String[] args) {
        List<String> names = List.of("Ahmet", "Mehmet", "Ayse");
        names.stream()
                .map(String::toUpperCase)
                .forEach(System.out::println);

        // forEach() does not guarantee processing order for parallel streams -- for a
        // sequential stream (the default, and the only kind used in this course) the
        // encounter order IS preserved, exactly like a plain for loop.
        names.stream().forEach(name -> System.out.print(name + " "));
        System.out.println();
    }
}
