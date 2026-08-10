import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

// A resource that needs to be acquired once the bean is fully constructed
// (all its dependencies set) and released exactly once, when the container
// shuts down -- exactly what @PostConstruct/@PreDestroy are for.
class ConnectionPool {
    private boolean open;

    @PostConstruct
    void open() {
        open = true;
        System.out.println("ConnectionPool opened");
    }

    void borrowConnection() {
        if (!open) {
            throw new IllegalStateException("Pool is not open");
        }
        System.out.println("Connection borrowed");
    }

    @PreDestroy
    void close() {
        open = false;
        System.out.println("ConnectionPool closed");
    }
}

@Configuration
class AppConfig {
    @Bean
    ConnectionPool connectionPool() {
        return new ConnectionPool();
    }
}

class PostConstructPreDestroyExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);
        // ConnectionPool opened

        ConnectionPool pool = context.getBean(ConnectionPool.class);
        pool.borrowConnection();
        // Connection borrowed

        // Closing the context runs every managed bean's @PreDestroy method --
        // exactly why manually-created objects (via plain `new`) never get this
        // for free, only container-managed beans do.
        context.close();
        // ConnectionPool closed
    }
}
