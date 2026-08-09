import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.lang.reflect.Method;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
@interface MyTest {
}

class Calculator {
    @MyTest
    void additionWorks() {
        if (2 + 2 != 4) {
            throw new AssertionError("Addition is broken");
        }
        System.out.println("additionWorks: PASSED");
    }

    @MyTest
    void subtractionWorks() {
        if (5 - 3 != 2) {
            throw new AssertionError("Subtraction is broken");
        }
        System.out.println("subtractionWorks: PASSED");
    }

    void notATest() {
        System.out.println("This should never run");
    }
}

// A drastically simplified sketch of what JUnit does internally: scan for
// annotated methods, then invoke each one reflectively.
class MiniTestRunner {
    public static void main(String[] args) throws Exception {
        Calculator target = new Calculator();

        for (Method method : Calculator.class.getDeclaredMethods()) {
            if (method.isAnnotationPresent(MyTest.class)) {
                method.invoke(target);
            }
        }
    }
}
