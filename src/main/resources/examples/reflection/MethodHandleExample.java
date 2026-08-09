import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.lang.reflect.Method;

class Greeter {
    String greet(String name) {
        return "Hello, " + name + "!";
    }
}

class MethodHandleExample {
    public static void main(String[] args) throws Throwable {
        Greeter greeter = new Greeter();

        // Classic reflection
        Method method = Greeter.class.getMethod("greet", String.class);
        System.out.println(method.invoke(greeter, "Ada")); // Hello, Ada!

        // MethodHandle — resolved once via a Lookup, then invoked directly.
        // The JIT can optimize a MethodHandle call site much more aggressively
        // than a classic Method.invoke() call.
        MethodHandles.Lookup lookup = MethodHandles.lookup();
        MethodHandle handle = lookup.findVirtual(Greeter.class, "greet",
                MethodType.methodType(String.class, String.class));
        System.out.println((String) handle.invoke(greeter, "Grace")); // Hello, Grace!
    }
}
