import java.lang.reflect.Method;
import java.util.Map;

class RequestBinderDemo {
    public static void main(String[] args) throws Exception {
        GreetingHandler handler = new GreetingHandler();
        Method method = GreetingHandler.class.getMethod("greet", String.class, String.class, String.class);

        Object result = RequestBinderSimulation.invoke(
                handler,
                method,
                Map.of("name", "Ayse"),
                Map.of(),
                Map.of("X-Client", "web"));

        System.out.println(result);
        // Hello Ayse (lang=en, client=web)
    }
}
