import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// Path variable'lar URL'in kendi içinde ({id} gibi) verilir; query parametreleri ise
// .param(ad, deger) ile eklenir -- ?page=0&size=10 formatındaki gerçek query string'i
// elle oluşturmaya gerek yoktur, MockMvc bunu sizin için kurar.
public class PathVariableQueryParamTestExample {

    record TopicSummary(String slug, int page, int size, String difficulty) {
    }

    @RestController
    static class TopicSearchController {
        @GetMapping("/api/categories/{categorySlug}/topics")
        TopicSummary search(@PathVariable String categorySlug,
                             @RequestParam(defaultValue = "0") int page,
                             @RequestParam(defaultValue = "20") int size,
                             @RequestParam(required = false) String difficulty) {
            return new TopicSummary(categorySlug, page, size, difficulty);
        }
    }

    public static void main(String[] args) throws Exception {
        MockMvc mockMvc = MockMvcBuilders.standaloneSetup(new TopicSearchController()).build();

        mockMvc.perform(get("/api/categories/{categorySlug}/topics", "spring-mvc")
                        .param("page", "1")
                        .param("size", "5")
                        .param("difficulty", "ADVANCED"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.slug").value("spring-mvc"))
                .andExpect(jsonPath("$.page").value(1))
                .andExpect(jsonPath("$.size").value(5))
                .andExpect(jsonPath("$.difficulty").value("ADVANCED"));

        // difficulty verilmeden de çalıştığını doğrula -- @RequestParam(required = false)
        // olduğu için 400 değil, null ile controller'a girer.
        mockMvc.perform(get("/api/categories/{categorySlug}/topics", "spring-mvc"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.page").value(0))
                .andExpect(jsonPath("$.size").value(20))
                .andExpect(jsonPath("$.difficulty").doesNotExist());

        System.out.println("Path variable ve query parametre testleri basarili.");
    }
}
