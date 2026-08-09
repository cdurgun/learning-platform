import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.lang.reflect.Method;

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
@interface Auditable {
    String value() default "";
}

class AccountService {
    @Auditable("balance-check")
    void checkBalance() {
        // ...
    }

    void internalHelper() {
        // not annotated
    }
}

class AnnotationExample {
    public static void main(String[] args) throws Exception {
        Method checkBalance = AccountService.class.getDeclaredMethod("checkBalance");
        Method internalHelper = AccountService.class.getDeclaredMethod("internalHelper");

        System.out.println(checkBalance.isAnnotationPresent(Auditable.class));   // true
        System.out.println(internalHelper.isAnnotationPresent(Auditable.class)); // false

        Auditable auditable = checkBalance.getAnnotation(Auditable.class);
        System.out.println(auditable.value()); // balance-check
    }
}
