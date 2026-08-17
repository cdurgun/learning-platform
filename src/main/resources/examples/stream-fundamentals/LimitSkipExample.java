import java.util.List;
import java.util.stream.IntStream;

// limit(n) keeps at most the first n elements and then stops the pipeline early.
// skip(n) discards the first n elements and keeps the rest. Together, they're the
// building blocks of pagination: skip((page - 1) * pageSize).limit(pageSize).
class LimitSkipExample {
    public static void main(String[] args) {
        List<Integer> numbers = IntStream.rangeClosed(1, 10).boxed().toList();

        List<Integer> firstThree = numbers.stream().limit(3).toList();
        System.out.println(firstThree);

        List<Integer> skipFirstSeven = numbers.stream().skip(7).toList();
        System.out.println(skipFirstSeven);

        // A simple "page 2 of size 3" -- skip the first page, then take the second.
        int pageSize = 3;
        int page = 2;
        List<Integer> secondPage = numbers.stream()
                .skip((long) (page - 1) * pageSize)
                .limit(pageSize)
                .toList();
        System.out.println(secondPage);
    }
}
