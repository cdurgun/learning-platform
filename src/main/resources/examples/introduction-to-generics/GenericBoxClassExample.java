public class GenericBoxClassExample {

    // A generic class: T is a type parameter, a placeholder for whatever
    // real type is supplied when Box is used. The class is written ONCE,
    // but works correctly for any type without any casting or duplication.
    static class Box<T> {
        private T content;

        void set(T content) {
            this.content = content;
        }

        T get() {
            return content;
        }
    }

    public static void main(String[] args) {
        Box<String> stringBox = new Box<>();
        stringBox.set("hello");
        String value = stringBox.get(); // no cast needed -- the compiler already knows it's a String

        Box<Integer> intBox = new Box<>();
        intBox.set(42);
        int number = intBox.get(); // same class, different type argument, still no cast

        System.out.println(value.toUpperCase());
        System.out.println(number * 2);
    }
}
