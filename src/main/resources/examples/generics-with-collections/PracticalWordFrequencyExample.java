import java.util.HashMap;
import java.util.Map;

public class PracticalWordFrequencyExample {

    // A practical, everyday use of Map<K, V>: counting how many times
    // each word appears -- the kind of code that shows up constantly in
    // real applications.
    static Map<String, Integer> countWords(String[] words) {
        Map<String, Integer> frequency = new HashMap<>();
        for (String word : words) {
            frequency.merge(word, 1, Integer::sum);
        }
        return frequency;
    }

    public static void main(String[] args) {
        String[] words = {"apple", "banana", "apple", "cherry", "banana", "apple"};

        Map<String, Integer> counts = countWords(words);
        for (Map.Entry<String, Integer> entry : counts.entrySet()) {
            System.out.println(entry.getKey() + ": " + entry.getValue());
        }
    }
}
