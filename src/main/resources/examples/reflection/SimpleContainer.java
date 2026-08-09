import java.lang.reflect.Constructor;
import java.util.HashMap;
import java.util.Map;

class Engine {
    String start() {
        return "Engine started";
    }
}

class Car {
    private final Engine engine;

    Car(Engine engine) {
        this.engine = engine;
    }

    String drive() {
        return engine.start() + " -> Car is driving";
    }
}

// A minimal constructor-injection container: given a type, it recursively
// resolves each constructor parameter, instantiates it, and caches the
// result as a singleton — the same core idea Spring's ApplicationContext
// uses, stripped down to its essence.
class SimpleContainer {
    private final Map<Class<?>, Object> singletons = new HashMap<>();

    @SuppressWarnings("unchecked")
    <T> T resolve(Class<T> type) throws ReflectiveOperationException {
        if (singletons.containsKey(type)) {
            return (T) singletons.get(type);
        }

        Constructor<?> constructor = type.getDeclaredConstructors()[0];
        Class<?>[] paramTypes = constructor.getParameterTypes();
        Object[] args = new Object[paramTypes.length];

        for (int i = 0; i < paramTypes.length; i++) {
            args[i] = resolve(paramTypes[i]);
        }

        Object instance = constructor.newInstance(args);
        singletons.put(type, instance);
        return (T) instance;
    }
}
