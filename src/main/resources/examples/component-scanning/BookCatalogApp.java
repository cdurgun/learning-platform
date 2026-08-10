import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

// A miniature version of this project's own three-layer structure
// (repository/service/controller) -- see "Bu Projenin Kendi Sınıfları:
// Gerçek Bir Component Scanning Örneği" for how NavigationService,
// TopicController, and the JPA repositories are wired the same way in
// practice.
@Repository
class BookRepository {
    private final List<String> books = new ArrayList<>(List.of("Java 21 Book", "Spring Boot Book"));

    List<String> findAll() {
        return books;
    }

    void save(String title) {
        books.add(title);
    }
}

@Service
class BookService {
    private final BookRepository bookRepository;

    @Autowired
    BookService(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    List<String> listBooks() {
        return bookRepository.findAll();
    }

    void addBook(String title) {
        bookRepository.save(title);
    }
}

@Component
class BookController {
    private final BookService bookService;

    @Autowired
    BookController(BookService bookService) {
        this.bookService = bookService;
    }

    void printCatalog() {
        for (String title : bookService.listBooks()) {
            System.out.println("- " + title);
        }
    }
}

@Configuration
@ComponentScan
class AppConfig {
}
