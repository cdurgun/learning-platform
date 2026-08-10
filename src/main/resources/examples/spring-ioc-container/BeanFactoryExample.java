import org.springframework.beans.factory.config.BeanDefinition;
import org.springframework.beans.factory.support.BeanDefinitionBuilder;
import org.springframework.beans.factory.support.DefaultListableBeanFactory;

interface NotificationSender {
    void send(String to, String message);
}

class EmailNotificationSender implements NotificationSender {
    EmailNotificationSender() {
        System.out.println("EmailNotificationSender constructed");
    }

    @Override
    public void send(String to, String message) {
        System.out.println("[email to " + to + "] " + message);
    }
}

class BeanFactoryExample {
    public static void main(String[] args) {
        // The root container interface -- everything else (including
        // ApplicationContext) builds on top of this. Registering a definition
        // here does not create anything yet.
        DefaultListableBeanFactory factory = new DefaultListableBeanFactory();

        BeanDefinition definition = BeanDefinitionBuilder
                .genericBeanDefinition(EmailNotificationSender.class)
                .getBeanDefinition();
        factory.registerBeanDefinition("emailSender", definition);

        System.out.println("Bean definition registered -- nothing constructed yet.");
        // Bean definition registered -- nothing constructed yet.

        // BeanFactory is lazy by nature: EmailNotificationSender's constructor only
        // runs on this line, the first time the bean is actually asked for.
        NotificationSender sender = factory.getBean("emailSender", NotificationSender.class);
        // EmailNotificationSender constructed

        sender.send("ayse@example.com", "Your order has been placed.");
        // [email to ayse@example.com] Your order has been placed.
    }
}
