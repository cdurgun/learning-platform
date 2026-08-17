import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class ListOfImmutableExample {
    public static void main(String[] args) {
        List<String> immutable = List.of("red", "green", "blue");
        System.out.println("List.of(): " + immutable);

        try {
            immutable.add("yellow");
        } catch (UnsupportedOperationException e) {
            System.out.println("add() on a List.of() result: " + e.getClass().getSimpleName());
        }

        try {
            immutable.set(0, "black");
        } catch (UnsupportedOperationException e) {
            System.out.println("set() on a List.of() result: " + e.getClass().getSimpleName());
        }

        // Collections.unmodifiableList(): an UNMODIFIABLE "view" of an existing list
        List<String> mutable = new ArrayList<>(List.of("a", "b"));
        List<String> readOnlyView = Collections.unmodifiableList(mutable);
        try {
            readOnlyView.add("c");
        } catch (UnsupportedOperationException e) {
            System.out.println("add() on unmodifiableList(): " + e.getClass().getSimpleName());
        }

        // But watch out: unmodifiableList() is just a VIEW, the original list can still change
        mutable.add("c");
        System.out.println("The view changes when the original list changes: " + readOnlyView);

        // List.copyOf(): creates a completely independent, separate immutable COPY
        List<String> independentCopy = List.copyOf(mutable);
        mutable.add("d");
        System.out.println("Original list changed: " + mutable);
        System.out.println("List.copyOf() copy was NOT affected: " + independentCopy);
    }
}
