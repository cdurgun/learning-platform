import java.util.AbstractList;

// java.util.AbstractList is a real, JDK-shipped abstract class: implement
// just get(int) and size(), and it gives you a fully working, read-only
// List implementation -- iterator(), contains(), indexOf(), toString(),
// even the for-each loop -- all built on top of those two methods.
class ReadOnlyRange extends AbstractList<Integer> {
    private final int start;
    private final int end;

    ReadOnlyRange(int start, int end) {
        this.start = start;
        this.end = end;
    }

    @Override
    public Integer get(int index) {
        return start + index;
    }

    @Override
    public int size() {
        return end - start;
    }
}

class ReadOnlyListExample {
    public static void main(String[] args) {
        ReadOnlyRange range = new ReadOnlyRange(5, 10);

        System.out.println(range);              // [5, 6, 7, 8, 9] -- toString() came for free
        System.out.println(range.contains(7));   // true -- contains() came for free too

        for (int n : range) { // the for-each loop came for free as well
            System.out.print(n + " ");
        }
        System.out.println();
    }
}
