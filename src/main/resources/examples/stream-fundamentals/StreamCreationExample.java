import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;

// A Stream doesn't store data -- it's a pipeline that pulls elements from a SOURCE.
// The three most common sources: a Collection's stream() method, Stream.of() for
// literal values, and Arrays.stream() for arrays.
class StreamCreationExample {
    public static void main(String[] args) {
        List<String> names = List.of("Ahmet", "Mehmet", "Ayse");
        Stream<String> fromCollection = names.stream();
        System.out.println(fromCollection.count());

        Stream<String> fromLiterals = Stream.of("a", "b", "c");
        System.out.println(fromLiterals.count());

        String[] array = {"x", "y", "z"};
        Stream<String> fromArray = Arrays.stream(array);
        System.out.println(fromArray.count());

        // Stream.empty() and Stream.generate()/Stream.iterate() are less common sources --
        // generate() needs a limit() or it never stops, since it has no natural end.
        Stream<Integer> generated = Stream.iterate(1, n -> n * 2).limit(5);
        System.out.println(generated.toList());
    }
}
