import java.util.ArrayList;
import java.util.List;

public class ListInvarianceExample {

    // If List<Object> WERE a List<String> (it isn't), this method would
    // let you sneak an Integer into a list that was really created as a
    // List<String> -- a broken promise the compiler will never allow.
    static void addNumber(List<Object> list) {
        list.add(42);
    }

    public static void main(String[] args) {
        List<String> names = new ArrayList<>();
        names.add("Alice");

        // addNumber(names); // would NOT compile -- List<String> is not a
        //     List<Object>, even though String IS an Object. If this line
        //     were allowed, addNumber(...) could insert an Integer into
        //     what the caller believes is purely a list of Strings --
        //     exactly the unsafety generics exist to prevent.

        List<Object> anything = new ArrayList<>();
        addNumber(anything); // fine -- this really is a List<Object>

        System.out.println(names);
        System.out.println(anything);
    }
}
