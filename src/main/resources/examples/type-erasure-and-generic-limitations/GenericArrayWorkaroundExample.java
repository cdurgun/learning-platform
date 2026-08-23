public class GenericArrayWorkaroundExample {

    static class SimpleStack<T> {
        // private T[] elements = new T[10]; // would NOT compile -- an
        //     array remembers its element type at RUNTIME (unlike a List),
        //     but erasure means there is no real T to give it at runtime.

        @SuppressWarnings("unchecked")
        private final T[] elements = (T[]) new Object[10]; // the standard
        // workaround: build an Object[], then cast it to T[] -- this
        // produces an "unchecked" compiler warning because the cast can't
        // truly be verified, but it's safe AS LONG AS this array is never
        // exposed outside the class as a T[] (only ever accessed through
        // methods like get/push below, which return individual T values).

        private int size = 0;

        void push(T value) {
            elements[size++] = value;
        }

        T pop() {
            return elements[--size];
        }
    }

    public static void main(String[] args) {
        SimpleStack<String> stack = new SimpleStack<>();
        stack.push("first");
        stack.push("second");

        System.out.println(stack.pop());
        System.out.println(stack.pop());
    }
}
