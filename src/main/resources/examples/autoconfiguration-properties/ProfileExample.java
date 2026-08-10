import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;

interface PaymentGateway {
    void charge(double amount);
}

// @Profile lets two completely different bean implementations exist side by
// side in the source code, with only one of them ever actually registered --
// chosen by which profile(s) are active. This is exactly how this project
// switches between application-dev.yml, application-test.yml, and
// application-prod.yml.
@Configuration
class PaymentConfig {

    @Bean
    @Profile("dev")
    PaymentGateway sandboxPaymentGateway() {
        return amount -> System.out.println("[sandbox] Pretending to charge $" + amount);
    }

    @Bean
    @Profile("prod")
    PaymentGateway realPaymentGateway() {
        return amount -> System.out.println("[real] Charging $" + amount + " via the payment provider");
    }
}

class ProfileExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext devContext = new AnnotationConfigApplicationContext();
        devContext.getEnvironment().setActiveProfiles("dev");
        devContext.register(PaymentConfig.class);
        devContext.refresh();
        devContext.getBean(PaymentGateway.class).charge(49.99);
        // [sandbox] Pretending to charge $49.99
        devContext.close();

        AnnotationConfigApplicationContext prodContext = new AnnotationConfigApplicationContext();
        prodContext.getEnvironment().setActiveProfiles("prod");
        prodContext.register(PaymentConfig.class);
        prodContext.refresh();
        prodContext.getBean(PaymentGateway.class).charge(49.99);
        // [real] Charging $49.99 via the payment provider
        prodContext.close();
    }
}
