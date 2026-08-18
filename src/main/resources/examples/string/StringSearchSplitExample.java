import java.util.Arrays;
import java.util.List;

public class StringSearchSplitExample {
    public static void main(String[] args) {
        String csv = "apple,banana,,cherry";

        // split() cuts a String into an array using a regex delimiter -- an empty
        // field (two delimiters in a row) still produces an empty String element.
        String[] parts = csv.split(",");
        System.out.println("split(\",\"): " + Arrays.toString(parts));
        System.out.println("parts.length: " + parts.length);

        // String.join() is the reverse operation: glue elements back together
        // with a separator.
        String joined = String.join(" | ", parts);
        System.out.println("String.join(\" | \", parts): " + joined);

        List<String> fromList = List.of("x", "y", "z");
        System.out.println("String.join(\"-\", List): " + String.join("-", fromList));

        // replace() replaces ALL occurrences of a literal substring (no regex).
        String sentence = "the cat sat on the mat";
        System.out.println("replace(\"at\", \"og\"): " + sentence.replace("at", "og"));

        // replaceAll() takes a REGEX, replaceFirst() only replaces the first match.
        System.out.println("replaceAll(\"\\\\s+\", \"_\"): " + sentence.replaceAll("\\s+", "_"));

        // trim() removes ASCII whitespace (<= U+0020) from both ends; strip()
        // (Java 11+) is the Unicode-aware version and is generally preferred now.
        String padded = "   spaced out   ";
        System.out.println("trim(): [" + padded.trim() + "]");
        System.out.println("strip(): [" + padded.strip() + "]");

        // Case conversion and equality that ignores case.
        System.out.println("\"Hello\".equalsIgnoreCase(\"HELLO\"): " + "Hello".equalsIgnoreCase("HELLO"));
        System.out.println("toLowerCase(): " + "MixedCase".toLowerCase());

        // repeat() (Java 11+) builds a String by repeating it N times.
        System.out.println("\"ab\".repeat(3): " + "ab".repeat(3));

        // compareTo() is lexicographic (dictionary) order -- negative, zero, or
        // positive, like Comparable in general.
        System.out.println("\"apple\".compareTo(\"banana\"): " + "apple".compareTo("banana"));
        System.out.println("\"banana\".compareTo(\"apple\"): " + "banana".compareTo("apple"));
        System.out.println("\"apple\".compareTo(\"apple\"): " + "apple".compareTo("apple"));
    }
}
