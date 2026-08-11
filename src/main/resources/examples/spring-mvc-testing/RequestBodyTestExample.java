import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// POST/PUT/PATCH gövdesi göndermek için content(...) ile ham baytları/string'i, ve
// contentType(...) ile Content-Type header'ını vermeniz gerekir -- Content-Type
// verilmezse Spring, hangi HttpMessageConverter'ın kullanılacağını bilemez ve
// isteği reddedebilir (415 Unsupported Media Type).
public class RequestBodyTestExample {

    record CreateNoteRequest(String title, String body) {
    }

    record NoteResponse(long id, String title) {
    }

    @RestController
    static class NoteController {
        @PostMapping("/notes")
        NoteResponse create(@RequestBody CreateNoteRequest request) {
            return new NoteResponse(1L, request.title());
        }
    }

    public static void main(String[] args) throws Exception {
        MockMvc mockMvc = MockMvcBuilders.standaloneSetup(new NoteController()).build();
        ObjectMapper objectMapper = new ObjectMapper();

        String requestJson = objectMapper.writeValueAsString(
                new CreateNoteRequest("Toplantı Notu", "Spring MVC testing bölümünü bitir"));

        mockMvc.perform(post("/notes")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.title").value("Toplantı Notu"));

        System.out.println("POST govdesi gonderildi ve yanit dogrulandi.");

        // content(requestJson) burada elle ObjectMapper ile serileştirildi -- gerçek
        // projelerde bu genelde küçük bir yardımcı metoda (örn. asJsonString(Object))
        // çıkarılır, çünkü hemen her yazma testinde tekrar eder.
    }
}
