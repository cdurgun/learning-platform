public class StringBuilderExample {
    public static void main(String[] args) {
        // Unlike String, StringBuilder is MUTABLE -- its methods change the same
        // object in place instead of returning a new one.
        StringBuilder sb = new StringBuilder("Hello");
        System.out.println("Initial: " + sb);

        sb.append(", World");
        System.out.println("After append(): " + sb);

        sb.append('!');
        System.out.println("After append(char): " + sb);

        sb.insert(5, " there");
        System.out.println("After insert(5, \" there\"): " + sb);

        sb.replace(0, 5, "Hi");
        System.out.println("After replace(0, 5, \"Hi\"): " + sb);

        sb.delete(2, 8);
        System.out.println("After delete(2, 8): " + sb);

        sb.reverse();
        System.out.println("After reverse(): " + sb);
        sb.reverse(); // put it back for the next step
        System.out.println("After reverse() again: " + sb);

        System.out.println("charAt(0): " + sb.charAt(0));
        System.out.println("length(): " + sb.length());

        // Only convert to an immutable String at the very end, once the building
        // is finished.
        String finalResult = sb.toString();
        System.out.println("Final String (via toString()): " + finalResult);

        // StringBuffer has the exact same API as StringBuilder, but every method
        // is synchronized -- it predates StringBuilder (Java 1.0 vs Java 5) and is
        // now mostly legacy: use it only if multiple threads truly share ONE
        // builder instance, otherwise StringBuilder is faster.
        StringBuffer buffer = new StringBuffer("legacy, thread-safe");
        buffer.append(" version");
        System.out.println("StringBuffer (synchronized, legacy): " + buffer);
    }
}
