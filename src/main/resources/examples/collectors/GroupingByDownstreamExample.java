import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

// groupingBy() accepts a second, "downstream" Collector -- instead of collecting each
// group into a List (the default), the downstream Collector decides what happens to
// each group's elements. counting() reduces each group to its size; mapping() lets you
// transform each element before it's collected into the group.
class GroupingByDownstreamExample {
    public static void main(String[] args) {
        List<String> names = List.of("Ahmet", "Ali", "Mehmet", "Ayse", "Ata");

        Map<Character, Long> countByFirstLetter = names.stream()
                .collect(Collectors.groupingBy(name -> name.charAt(0), Collectors.counting()));
        System.out.println(countByFirstLetter);

        // mapping(): transform each element (here, to its length) BEFORE grouping it.
        Map<Character, List<Integer>> lengthsByFirstLetter = names.stream()
                .collect(Collectors.groupingBy(
                        name -> name.charAt(0),
                        Collectors.mapping(String::length, Collectors.toList())));
        System.out.println(lengthsByFirstLetter);
    }
}
