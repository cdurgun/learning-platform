import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;

// Without an argument, @Component's bean name defaults to the class name with
// its first letter lowercased ("customBeanNameExample" style). Passing a
// String changes it explicitly.
@Component("primaryEmailSender")
class EmailSender {
    void send(String message) {
        System.out.println("[email] " + message);
    }
}

@Component
class DefaultNamedSender {
    void send(String message) {
        System.out.println("[default] " + message);
    }
}

@Configuration
@ComponentScan
class AppConfig {
}

class CustomBeanNameExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);

        // The explicit name from @Component("primaryEmailSender") -- "emailSender"
        // (the default that would've come from the class name) does not exist.
        EmailSender sender = (EmailSender) context.getBean("primaryEmailSender");
        sender.send("Custom name resolved successfully");
        // [email] Custom name resolved successfully

        // No name given -- defaults to the class name, lowercased at the start.
        System.out.println(context.containsBean("defaultNamedSender")); // true

        context.close();
    }
}
