import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

public class HashSetEqualsHashCodeExample {

    // equals()/hashCode() NOT OVERRIDDEN -- Object's default is used, meaning
    // "equality" only means the SAME reference (==).
    static class PointWithoutOverride {
        final int x, y;

        PointWithoutOverride(int x, int y) {
            this.x = x;
            this.y = y;
        }

        @Override
        public String toString() {
            return "(" + x + "," + y + ")";
        }
    }

    // equals()/hashCode() OVERRIDDEN CORRECTLY -- "equality" now means the x/y
    // values are the same.
    static class PointWithOverride {
        final int x, y;

        PointWithOverride(int x, int y) {
            this.x = x;
            this.y = y;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (!(o instanceof PointWithOverride other)) return false;
            return x == other.x && y == other.y;
        }

        @Override
        public int hashCode() {
            return Objects.hash(x, y);
        }

        @Override
        public String toString() {
            return "(" + x + "," + y + ")";
        }
    }

    public static void main(String[] args) {
        Set<PointWithoutOverride> withoutOverride = new HashSet<>();
        withoutOverride.add(new PointWithoutOverride(1, 1));
        withoutOverride.add(new PointWithoutOverride(1, 1)); // looks "the same" but is a DIFFERENT object
        System.out.println("WITHOUT overriding equals()/hashCode(), added two (1,1), size: "
                + withoutOverride.size() + " -- HashSet thought they were DIFFERENT!");

        Set<PointWithOverride> withOverride = new HashSet<>();
        withOverride.add(new PointWithOverride(1, 1));
        withOverride.add(new PointWithOverride(1, 1)); // now genuinely considered "equal"
        System.out.println("WITH equals()/hashCode() overridden, added two (1,1), size: "
                + withOverride.size() + " -- HashSet correctly deduplicated them.");
    }
}
