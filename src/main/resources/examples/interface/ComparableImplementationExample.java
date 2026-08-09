import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

// Comparable<T> is one of the JDK's oldest interfaces (java.lang, since
// JDK 1.2): implementing it gives a type a single, "natural" ordering that
// Collections.sort(), Arrays.sort(), TreeSet, and TreeMap all understand
// automatically — no separate sorting code needed anywhere.
class Player implements Comparable<Player> {
    private final String name;
    private final int score;

    Player(String name, int score) {
        this.name = name;
        this.score = score;
    }

    @Override
    public int compareTo(Player other) {
        return Integer.compare(this.score, other.score);
    }

    @Override
    public String toString() {
        return name + "(" + score + ")";
    }
}

class ComparableImplementationExample {
    public static void main(String[] args) {
        List<Player> players = new ArrayList<>(List.of(
                new Player("Ada", 42),
                new Player("Linus", 17),
                new Player("Grace", 88)));

        Collections.sort(players);
        System.out.println(players); // [Linus(17), Ada(42), Grace(88)]
    }
}
