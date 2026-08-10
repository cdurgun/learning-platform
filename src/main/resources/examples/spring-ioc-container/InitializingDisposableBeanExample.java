import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

// The interface-based alternative to @PostConstruct/@PreDestroy -- it predates
// the annotations and still works, but ties this class's source code directly
// to Spring's own interfaces (compare with "@PostConstruct ve @PreDestroy",
// which needs no Spring-specific supertype at all).
class LegacyStyleConnectionPool implements InitializingBean, DisposableBean {
    @Override
    public void afterPropertiesSet() {
        System.out.println("ConnectionPool opened (InitializingBean)");
    }

    @Override
    public void destroy() {
        System.out.println("ConnectionPool closed (DisposableBean)");
    }
}

@Configuration
class AppConfig {
    @Bean
    LegacyStyleConnectionPool legacyStyleConnectionPool() {
        return new LegacyStyleConnectionPool();
    }
}

class InitializingDisposableBeanExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        // ConnectionPool opened (InitializingBean)

        context.close();
        // ConnectionPool closed (DisposableBean)
    }
}
