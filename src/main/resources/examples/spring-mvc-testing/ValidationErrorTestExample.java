import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ProblemDetail;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.util.stream.Collectors;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// standaloneSetup(...), Bean Validation classpath'te olduğu için VARSAYILAN OLARAK bir
// validator kurar -- yani @Valid ek bir .setValidator(...) çağrısı olmadan çalışır.
// Ancak @ControllerAdvice sınıfları OTOMATİK taranmaz: geçerli bir hata gövdesi (400 +
// ProblemDetail) almak için advice'ı .setControllerAdvice(...) ile elle eklemeniz gerekir
// -- bkz. "Validation ve Exception Handling" dersindeki "@RestControllerAdvice: Global
// Hata Yönetimi" bölümü.
public class ValidationErrorTestExample {

    record CreateTopicRequest(@NotBlank String slug, @Min(1) int estimatedMinutes) {
    }

    @RestController
    static class TopicCreationController {
        @PostMapping("/api/topics")
        String create(@Valid @RequestBody CreateTopicRequest request) {
            return "created: " + request.slug();
        }
    }

    @RestControllerAdvice
    static class ValidationAdvice {
        @ExceptionHandler(MethodArgumentNotValidException.class)
        ProblemDetail handleValidation(MethodArgumentNotValidException e) {
            ProblemDetail problem = ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, "Validation failed");
            problem.setProperty("errors", e.getBindingResult().getFieldErrors().stream()
                    .map(fe -> fe.getField() + ": " + fe.getDefaultMessage())
                    .collect(Collectors.toList()));
            return problem;
        }
    }

    public static void main(String[] args) throws Exception {
        MockMvc mockMvc = MockMvcBuilders.standaloneSetup(new TopicCreationController())
                .setControllerAdvice(new ValidationAdvice())
                .build();
        ObjectMapper objectMapper = new ObjectMapper();

        // slug boş VE estimatedMinutes 0 -- iki alan da ihlalde.
        String invalidJson = objectMapper.writeValueAsString(new CreateTopicRequest("", 0));

        mockMvc.perform(post("/api/topics")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(invalidJson))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.detail").value("Validation failed"))
                .andExpect(jsonPath("$.errors.length()").value(2));

        System.out.println("Gecersiz govde 400 + ProblemDetail ile reddedildi.");

        // Geçerli bir istekle karşılaştır: aynı controller, aynı advice, farklı sonuç.
        String validJson = objectMapper.writeValueAsString(new CreateTopicRequest("spring-mvc-testing", 45));
        mockMvc.perform(post("/api/topics")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(validJson))
                .andExpect(status().isOk());

        System.out.println("Gecerli govde ise 200 ile kabul edildi.");
    }
}
