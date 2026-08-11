import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// @RestController'lar JSON döndürür; view()/model() burada anlamsızdır (view yok).
// jsonPath(...) yanıt gövdesinin İÇİNE, bir JSONPath ifadesiyle bakar -- tüm gövdeyi
// elle string karşılaştırmaya (content().json(...)) tercihen, tek tek alan doğrulamak
// için kullanışlıdır; özellikle gövdenin bir kısmını (örn. sunucu tarafından üretilen
// bir zaman damgasını) görmezden gelmek istediğinizde.
public class JsonPathAssertionExample {

    record BookResponse(String title, String author, int pageCount, boolean available) {
    }

    @RestController
    static class BookController {
        @GetMapping("/books/{id}")
        BookResponse book(@PathVariable String id) {
            return new BookResponse("Effective Java", "Joshua Bloch", 412, true);
        }
    }

    public static void main(String[] args) throws Exception {
        MockMvc mockMvc = MockMvcBuilders.standaloneSetup(new BookController()).build();

        mockMvc.perform(get("/books/1"))
                .andExpect(status().isOk())
                // "$.alan": kök nesnenin bir alanı.
                .andExpect(jsonPath("$.title").value("Effective Java"))
                .andExpect(jsonPath("$.author").value("Joshua Bloch"))
                .andExpect(jsonPath("$.pageCount").value(412))
                .andExpect(jsonPath("$.available").value(true))
                // jsonPath(...).exists() / doesNotExist(): alanın varlığını, değerine
                // hiç bakmadan doğrular.
                .andExpect(jsonPath("$.isbn").doesNotExist());

        System.out.println("JSON gövde alanlari jsonPath ile dogrulandi.");

        // Not: bir liste dönseydi (örn. List<BookResponse>), "$[0].title" gibi bir
        // dizi indeksleme ifadesi, "$.length()" ise eleman sayısı için kullanılabilir.
    }
}
