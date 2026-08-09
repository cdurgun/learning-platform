// Both declarations below are 100% equivalent — an interface method with no
// body is implicitly `public abstract`, whether you write those keywords or not.
interface Greeter {
    void greet(String name);
}

interface GreeterExplicit {
    public abstract void greet(String name);
}

class EnglishGreeter implements Greeter {
    // Must be `public` here — you can never REDUCE visibility when overriding,
    // and the interface method is implicitly public.
    @Override
    public void greet(String name) {
        System.out.println("Hello, " + name + "!");
    }
}

class AbstractMethodExample {
    public static void main(String[] args) {
        Greeter greeter = new EnglishGreeter();
        greeter.greet("Ada"); // Hello, Ada!
    }
}
