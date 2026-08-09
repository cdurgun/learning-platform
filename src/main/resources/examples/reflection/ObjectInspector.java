import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

// A generic "dump everything you can see" utility: given any object, prints
// all of its declared fields (with their current values) and all of its
// declared methods (with their signatures) — regardless of access modifier.
class ObjectInspector {
    static void inspect(Object obj) throws IllegalAccessException {
        Class<?> type = obj.getClass();
        System.out.println("Class: " + type.getName());

        System.out.println("Fields:");
        for (Field field : type.getDeclaredFields()) {
            field.setAccessible(true);
            System.out.println("  " + Modifier.toString(field.getModifiers())
                    + " " + field.getType().getSimpleName()
                    + " " + field.getName()
                    + " = " + field.get(obj));
        }

        System.out.println("Methods:");
        for (Method method : type.getDeclaredMethods()) {
            System.out.println("  " + Modifier.toString(method.getModifiers())
                    + " " + method.getReturnType().getSimpleName()
                    + " " + method.getName() + "(...)");
        }
    }
}
