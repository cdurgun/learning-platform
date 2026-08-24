import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import java.util.List;

// Extending JpaSpecificationExecutor<Topic> ALONGSIDE JpaRepository<Topic, Long>
// is what actually gives this project's own TopicRepository the ability to
// accept a Specification at all -- without it, a Specification has
// nothing to be run against.
interface TopicSpecificationRepositoryExample
        extends JpaRepository<TopicSpecExample, Long>, JpaSpecificationExecutor<TopicSpecExample> {

    // No new methods are declared here -- JpaSpecificationExecutor already
    // contributes findAll(Specification), findOne(Specification),
    // count(Specification), and more, the same way CrudRepository already
    // contributed save/findById/findAll in "Entities and the Repository
    // Abstraction."
}

class TopicSpecExample {
}

class JpaSpecificationExecutorExample {
    public static void main(String[] args) {
        // repository.findAll(hasDifficulty("ADVANCED")) would now generate
        // a real SELECT ... WHERE difficulty = 'ADVANCED' -- the
        // Specification from SingleSpecificationExample, finally given
        // something to run against.
        System.out.println("see SingleSpecificationExample for the Specification itself");
    }
}
