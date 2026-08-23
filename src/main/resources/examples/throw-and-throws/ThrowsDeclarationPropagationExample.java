import java.io.FileNotFoundException;

public class ThrowsDeclarationPropagationExample {

    public static void main(String[] args) {
        try {
            step1();
        } catch (FileNotFoundException e) {
            System.out.println("Caught at the top: " + e.getMessage());
        }
    }

    // Each method here declares "throws" instead of catching -- the checked
    // exception simply passes through, unhandled, all the way up the call
    // chain until something finally catches it in main. "throws" costs
    // nothing to write and does not stop execution by itself; it is a
    // compile-time declaration, not a runtime action like "throw".
    static void step1() throws FileNotFoundException {
        step2();
    }

    static void step2() throws FileNotFoundException {
        step3();
    }

    static void step3() throws FileNotFoundException {
        throw new FileNotFoundException("report.csv");
    }
}
