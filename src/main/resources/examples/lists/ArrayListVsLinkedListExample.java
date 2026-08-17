import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public class ArrayListVsLinkedListExample {
    public static void main(String[] args) {
        int size = 20_000;
        List<Integer> arrayList = new ArrayList<>();
        List<Integer> linkedList = new LinkedList<>();
        for (int i = 0; i < size; i++) {
            arrayList.add(i);
            linkedList.add(i);
        }

        int middle = size / 2;
        int warmupRounds = 3_000;
        int timedRounds = 3_000;

        // Warm-up: run both paths a lot BEFORE measuring, so the JIT can optimize both --
        // a single, un-warmed-up measurement can be misleading (whichever path runs first
        // can look unfairly slow).
        for (int i = 0; i < warmupRounds; i++) {
            arrayList.get(middle);
            linkedList.get(middle);
        }

        long arrayListStart = System.nanoTime();
        for (int i = 0; i < timedRounds; i++) {
            arrayList.get(middle);
        }
        long arrayListNanos = System.nanoTime() - arrayListStart;

        long linkedListStart = System.nanoTime();
        for (int i = 0; i < timedRounds; i++) {
            linkedList.get(middle);
        }
        long linkedListNanos = System.nanoTime() - linkedListStart;

        System.out.println("get(middle element), " + timedRounds + " times, a " + size + "-element list:");
        System.out.println("  ArrayList:  " + (arrayListNanos / 1_000_000) + " ms");
        System.out.println("  LinkedList: " + (linkedListNanos / 1_000_000) + " ms");

        // Second measurement: inserting at the front (add(0, ...))
        List<Integer> arrayList2 = new ArrayList<>();
        List<Integer> linkedList2 = new LinkedList<>();
        int addRounds = 20_000;

        for (int i = 0; i < 2_000; i++) {
            arrayList2.add(0, i);
            linkedList2.add(0, i);
        }
        arrayList2.clear();
        linkedList2.clear();

        long arrayListAddStart = System.nanoTime();
        for (int i = 0; i < addRounds; i++) {
            arrayList2.add(0, i);
        }
        long arrayListAddNanos = System.nanoTime() - arrayListAddStart;

        long linkedListAddStart = System.nanoTime();
        for (int i = 0; i < addRounds; i++) {
            linkedList2.add(0, i);
        }
        long linkedListAddNanos = System.nanoTime() - linkedListAddStart;

        System.out.println();
        System.out.println("add(0, element), " + addRounds + " times (inserting at the front):");
        System.out.println("  ArrayList:  " + (arrayListAddNanos / 1_000_000) + " ms");
        System.out.println("  LinkedList: " + (linkedListAddNanos / 1_000_000) + " ms");
    }
}
