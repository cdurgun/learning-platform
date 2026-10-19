import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

// Collectors.toList()/toSet() are the general-purpose way to collect a stream into a
// collection. Unlike Stream.toList() (always unmodifiable), Collectors.toList() makes
// no guarantee about the returned List's type or mutability.
class ToListToSetExample {
    public static void main(String[] args) {
        List<String> names = List.of("Ahmet", "Mehmet", "Ayse", "Ahmet");

        // Fine for just gathering elements -- we only read the result.
        List<String> upper = names.stream()
                .map(String::toUpperCase)
                .collect(Collectors.toList());
        System.out.println(upper);

        // Need to modify the result? Ask for a specific, mutable collection.
        List<String> mutableList = names.stream()
                .map(String::toUpperCase)
                .collect(Collectors.toCollection(ArrayList::new));
        mutableList.add("EXTRA");
        System.out.println(mutableList);

        // toSet() removes duplicates the way any Set does -- no guaranteed order.
        Set<String> unique = names.stream().collect(Collectors.toSet());
        System.out.println(unique.size());
    }
}
