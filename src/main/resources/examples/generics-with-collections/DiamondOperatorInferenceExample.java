import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DiamondOperatorInferenceExample {

    public static void main(String[] args) {
        // The diamond operator, <>, lets the constructor's type argument be
        // INFERRED from the variable's declared type -- no need to repeat
        // "String" on both sides.
        List<String> names = new ArrayList<>(); // infers ArrayList<String>
        names.add("Alice");

        Map<String, Integer> ages = new HashMap<>(); // infers HashMap<String, Integer>
        ages.put("Alice", 30);

        // "var" infers the variable's type from the right-hand side instead
        // -- here the compiler works out that scores is a List<Integer>,
        // purely from what List.of(...) returns.
        var scores = List.of(90, 85, 78);

        System.out.println(names);
        System.out.println(ages);
        System.out.println(scores);
    }
}
