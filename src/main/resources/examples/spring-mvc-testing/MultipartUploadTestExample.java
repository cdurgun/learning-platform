import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

// MockMultipartFile, spring-test'in kendisidir (spring-boot-starter-test ile gelir,
// test scope) -- "Advanced Spring MVC" dersindeki MultipartUploadControllerExample'ın
// aksine (o örnek main-scope olduğu için MultipartFile'ı elle implemente etmişti),
// burada test scope olduğumuz için gerçek MockMultipartFile'ı doğrudan kullanabiliyoruz.
public class MultipartUploadTestExample {

    record UploadResult(String filename, long size, String contentType) {
    }

    @RestController
    static class UploadController {
        @PostMapping("/api/uploads")
        UploadResult upload(@RequestParam("file") MultipartFile file) {
            return new UploadResult(file.getOriginalFilename(), file.getSize(), file.getContentType());
        }
    }

    public static void main(String[] args) throws Exception {
        MockMvc mockMvc = MockMvcBuilders.standaloneSetup(new UploadController()).build();

        MockMultipartFile file = new MockMultipartFile(
                "file",                          // @RequestParam adıyla eşleşen part adı
                "notes.txt",                      // orijinal dosya adı
                "text/plain",                     // content type
                "spring-mvc-testing notlari".getBytes());

        // multipart(...): normal get()/post() yerine, multipart/form-data gövdesi
        // kuran özel bir request builder.
        mockMvc.perform(multipart("/api/uploads").file(file))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.filename").value("notes.txt"))
                .andExpect(jsonPath("$.contentType").value("text/plain"))
                .andExpect(jsonPath("$.size").value(file.getSize()));

        System.out.println("Multipart dosya yukleme testi basarili.");

        // Boyut sınırı ihlali gibi senaryolar için (bkz. Advanced Spring MVC dersindeki
        // "Multipart Boyut Sınırları" bölümü), MaxUploadSizeExceededException'ı yakalayan
        // bir @RestControllerAdvice, ValidationErrorTestExample'daki desenin aynısıyla
        // eklenebilir.
    }
}
