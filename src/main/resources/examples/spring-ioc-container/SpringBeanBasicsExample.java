import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

interface ReceiptPrinter {
    void print(String item);
}

class ConsoleReceiptPrinter implements ReceiptPrinter {
    @Override
    public void print(String item) {
        System.out.println("[receipt] " + item);
    }
}

@Configuration
class AppConfig {
    @Bean
    ReceiptPrinter receiptPrinter() {
        return new ConsoleReceiptPrinter();
    }
}

class SpringBeanBasicsExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);

        // Every object the container manages -- not just the ones you wrote a
        // @Bean method for, but Spring's own internal infrastructure beans too --
        // shows up here.
        for (String name : context.getBeanDefinitionNames()) {
            System.out.println(name);
        }
        // receiptPrinter
        // ...plus several internal Spring infrastructure beans...

        System.out.println(context.containsBean("receiptPrinter")); // true

        ReceiptPrinter byType = context.getBean(ReceiptPrinter.class);
        ReceiptPrinter byName = (ReceiptPrinter) context.getBean("receiptPrinter");
        System.out.println(byType == byName); // true -- both point at the same singleton

        context.close();
    }
}
