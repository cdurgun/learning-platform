import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

// A BeanPostProcessor is infrastructure that wraps around EVERY bean's
// initialization -- it runs immediately before and after each bean's
// @PostConstruct step, for every bean the context manages.
class LoggingBeanPostProcessor implements BeanPostProcessor {
    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("[BeanPostProcessor] before init: " + beanName);
        return bean;
    }

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("[BeanPostProcessor] after init: " + beanName);
        return bean;
    }
}

class LifecycleLoggingBean {
    LifecycleLoggingBean() {
        System.out.println("1. Constructor");
    }

    @PostConstruct
    void init() {
        System.out.println("3. @PostConstruct");
    }

    @PreDestroy
    void cleanup() {
        System.out.println("5. @PreDestroy");
    }
}

@Configuration
class AppConfig {
    @Bean
    LoggingBeanPostProcessor loggingBeanPostProcessor() {
        return new LoggingBeanPostProcessor();
    }

    @Bean
    LifecycleLoggingBean lifecycleLoggingBean() {
        return new LifecycleLoggingBean();
    }
}

class BeanLifecyclePhasesExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        // 1. Constructor
        // [BeanPostProcessor] before init: lifecycleLoggingBean
        // 3. @PostConstruct
        // [BeanPostProcessor] after init: lifecycleLoggingBean

        System.out.println("4. Bean is fully ready and in use");
        // 4. Bean is fully ready and in use

        context.close();
        // 5. @PreDestroy
    }
}
