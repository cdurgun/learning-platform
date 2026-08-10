import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.ComponentScan.Filter;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.FilterType;
import org.springframework.stereotype.Component;

@Component
class IncludedBean {
    String describe() {
        return "I was scanned and registered.";
    }
}

@Component
class ExcludedBean {
    String describe() {
        return "I should never be registered.";
    }
}

// In a real project (like this one, where @SpringBootApplication on
// LearningPlatformApplication implicitly scans com.cdurgun.learning and
// everything under it), @ComponentScan's basePackages tells the container
// WHERE to look. Here, since AppConfig and the @Component classes above all
// live in the same (default) package, a bare @ComponentScan is enough to
// find them -- the excludeFilter below is what actually keeps ExcludedBean out.
@Configuration
@ComponentScan(excludeFilters = @Filter(type = FilterType.ASSIGNABLE_TYPE, classes = ExcludedBean.class))
class AppConfig {
}

class ComponentScanConfigExample {
    public static void main(String[] args) {
        AnnotationConfigApplicationContext context = new AnnotationConfigApplicationContext(AppConfig.class);

        System.out.println(context.getBean(IncludedBean.class).describe());
        // I was scanned and registered.

        System.out.println(context.containsBean("excludedBean")); // false

        context.close();
    }
}
