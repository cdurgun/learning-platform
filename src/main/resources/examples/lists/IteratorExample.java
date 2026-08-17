import java.util.ArrayList;
import java.util.ConcurrentModificationException;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

public class IteratorExample {
    public static void main(String[] args) {
        List<Integer> numbers = new ArrayList<>(List.of(1, 2, 3, 4, 5, 6));

        // Safe removal with Iterator: use Iterator.remove() instead of calling
        // List.remove() DURING a for-each loop.
        Iterator<Integer> it = numbers.iterator();
        while (it.hasNext()) {
            int value = it.next();
            if (value % 2 == 0) {
                it.remove(); // safe -- the iterator updates its own internal bookkeeping
            }
        }
        System.out.println("Even numbers removed with Iterator.remove(): " + numbers);

        // ListIterator: unlike Iterator, it can move in BOTH directions (hasPrevious/previous)
        // and also supports add()/set().
        List<String> letters = new ArrayList<>(List.of("a", "b", "c"));
        ListIterator<String> listIt = letters.listIterator();
        while (listIt.hasNext()) {
            String value = listIt.next();
            listIt.set(value.toUpperCase());
        }
        System.out.println("Converted to uppercase with ListIterator.set(): " + letters);

        while (listIt.hasPrevious()) {
            System.out.println("going backwards: " + listIt.previous());
        }

        // REAL ERROR: calling List.remove() directly DURING a for-each loop
        List<Integer> unsafe = new ArrayList<>(List.of(10, 20, 30, 40));
        try {
            for (Integer value : unsafe) {
                if (value == 20) {
                    unsafe.remove(value); // throws ConcurrentModificationException
                }
            }
        } catch (ConcurrentModificationException e) {
            System.out.println("List.remove() during a for-each loop: " + e.getClass().getSimpleName());
        }
    }
}
