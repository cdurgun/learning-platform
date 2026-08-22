import java.util.ArrayList;
import java.util.List;

public class EnhancedForCollectionExample {
    public static void main(String[] args) {
        List<String> languages = new ArrayList<>();
        languages.add("Java");
        languages.add("Kotlin");
        languages.add("TypeScript");

        // Enhanced for works on anything Iterable, not just arrays -- List,
        // Set, and every other collection type included.
        for (String language : languages) {
            System.out.println("Language: " + language);
        }

        int totalLength = 0;
        for (String language : languages) {
            totalLength += language.length();
        }
        System.out.println("Total character count: " + totalLength);
    }
}
