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

        // forEach() makes no promise about the order it visits the elements in -- not even on
        // a sequential stream (the JDK keeps encounter order there in practice, but the API
        // does not guarantee it), and on a parallel stream the order really does vary.
        // forEachOrdered() processes the elements in encounter order on any stream.
        names.stream().forEachOrdered(name -> System.out.print(name + " "));
        System.out.println();
    }
}
