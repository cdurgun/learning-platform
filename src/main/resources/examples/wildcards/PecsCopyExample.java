import java.util.ArrayList;
import java.util.List;

public class PecsCopyExample {

    // The textbook PECS method: copying reads from "src" (a PRODUCER of T,
    // so "extends") and writes into "dest" (a CONSUMER of T, so "super").
    // Neither wildcard could do this job alone -- "src" must be readable
    // as T, and "dest" must be writable with a T.
    static <T> void copy(List<? extends T> src, List<? super T> dest) {
        for (T item : src) {
            dest.add(item);
        }
    }

    public static void main(String[] args) {
        List<Integer> integers = List.of(1, 2, 3);
        List<Number> destination = new ArrayList<>();

        copy(integers, destination); // T is inferred as Number here

        System.out.println(destination);
    }
}
