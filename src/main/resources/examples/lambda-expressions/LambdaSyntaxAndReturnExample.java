import java.util.function.BinaryOperator;

// A functional interface with one abstract method -- everything this file's lambdas
// need to demonstrate parameter/return syntax against.
interface Greeting {
    String greet(String name);
}

// Every form lambda syntax can take, side by side: parameter count, parentheses
// rules, and expression-body vs block-body.
class LambdaSyntaxAndReturnExample {
    public static void main(String[] args) {
        // Zero parameters -- empty parentheses are required, never optional.
        Runnable sayHello = () -> System.out.println("Hello!");
        sayHello.run();

        // One parameter -- parentheses are OPTIONAL when there's exactly one and it
        // has no type annotation, so both of these compile:
        Greeting shout = name -> name.toUpperCase() + "!";
        Greeting shoutParens = (name) -> name.toUpperCase() + "!";
        System.out.println(shout.greet("ayse"));

        // Two or more parameters -- parentheses become MANDATORY.
        BinaryOperator<Integer> max = (a, b) -> a > b ? a : b;
        System.out.println(max.apply(3, 7));

        // Expression body: a single expression, its value IS the return value --
        // no "return" keyword, no braces, no semicolon inside.
        Greeting expressionBody = name -> "Hi, " + name;
        System.out.println(expressionBody.greet("Fatma"));

        // Block body: braces required as soon as you need more than one statement --
        // and once you're in a block body, "return" becomes EXPLICIT and mandatory
        // for every path that produces a value.
        Greeting blockBody = name -> {
            String trimmed = name.trim();
            if (trimmed.isEmpty()) {
                return "Hi, stranger";
            }
            return "Hi, " + trimmed;
        };
        System.out.println(blockBody.greet("  Mehmet  "));
        System.out.println(blockBody.greet("   "));
    }
}
