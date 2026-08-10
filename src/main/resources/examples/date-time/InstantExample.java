import java.time.Instant;

class InstantExample {
    public static void main(String[] args) {
        Instant now = Instant.now(); // varies depending on when you run this
        System.out.println("Now: " + now);

        Instant epoch = Instant.EPOCH;
        System.out.println("Epoch: " + epoch);

        Instant fixed = Instant.ofEpochSecond(1_700_000_000L);
        System.out.println("Fixed instant: " + fixed);

        Instant later = fixed.plusSeconds(3600); // one hour later
        System.out.println("An hour later: " + later);
    }
}
