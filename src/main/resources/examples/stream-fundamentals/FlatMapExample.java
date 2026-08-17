import java.util.Arrays;
import java.util.List;

// map() turns each element into ONE new element -- if the mapping function itself
// returns a Stream/List, map() produces a Stream of Streams, which is rarely what you
// want. flatMap() turns each element into a Stream and then MERGES all of those
// streams into a single, flat stream -- exactly the tool for "list of lists" ->
// "single list" problems.
class FlatMapExample {
    public static void main(String[] args) {
        List<List<String>> nested = List.of(
                List.of("a", "b"),
                List.of("c"),
                List.of("d", "e", "f")
        );

        // map(List::stream) would give a Stream<Stream<String>> -- each inner list
        // becomes its OWN stream, still nested one level too deep to use directly.
        long innerStreamCount = nested.stream().map(List::stream).count();
        System.out.println(innerStreamCount);

        // flatMap(List::stream) merges every inner stream into one flat Stream<String>.
        List<String> flat = nested.stream()
                .flatMap(List::stream)
                .toList();
        System.out.println(flat);

        // A common real use: splitting each sentence into words, then flattening into
        // a single list of all words across all sentences.
        List<String> sentences = List.of("hello world", "java streams");
        List<String> words = sentences.stream()
                .flatMap(sentence -> Arrays.stream(sentence.split(" ")))
                .toList();
        System.out.println(words);
    }
}
