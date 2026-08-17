import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Stack;

public class ArrayDequeAsStackExample {
    public static void main(String[] args) {
        // The official recommendation (per the java.util.Stack javadoc itself) is to
        // use Deque as a stack via push()/pop(), NOT the legacy Stack class.
        Deque<Integer> stack = new ArrayDeque<>();
        stack.push(1);
        stack.push(2);
        stack.push(3); // last pushed...

        System.out.println("Stack (as Deque): " + stack);
        System.out.println("peek() (top of stack): " + stack.peek());
        System.out.println("pop(): " + stack.pop()); // ...is first popped: LIFO
        System.out.println("Stack after pop(): " + stack);

        // The old java.util.Stack class still works and gives the same LIFO
        // behavior, but it extends Vector, which means it inherits synchronized
        // methods (unnecessary overhead in single-threaded code) and index-based
        // methods that don't make sense for a stack (like insertElementAt()).
        Stack<Integer> legacyStack = new Stack<>();
        legacyStack.push(10);
        legacyStack.push(20);
        System.out.println("Legacy Stack: " + legacyStack + ", pop(): " + legacyStack.pop());
    }
}
