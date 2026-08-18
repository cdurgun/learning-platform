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

// To send a POST/PUT/PATCH body, you need to provide the raw bytes/string via
// content(...), and the Content-Type header via contentType(...) -- if Content-Type
// isn't provided, Spring won't know which HttpMessageConverter to use and may
// reject the request (415 Unsupported Media Type).
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
                new CreateNoteRequest("Meeting Note", "Finish the Spring MVC testing section"));

        mockMvc.perform(post("/notes")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(requestJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value(1))
                .andExpect(jsonPath("$.title").value("Meeting Note"));

        System.out.println("POST body sent and response verified.");

        // content(requestJson) is serialized here by hand with ObjectMapper -- in real
        // projects this is usually extracted into a small helper method (e.g.
        // asJsonString(Object)), since it repeats in almost every write test.
    }
}
