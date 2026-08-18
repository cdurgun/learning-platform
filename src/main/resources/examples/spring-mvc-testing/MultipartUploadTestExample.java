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

// MockMultipartFile comes from spring-test itself (bundled with spring-boot-starter-test,
// test scope) -- unlike the MultipartUploadControllerExample in the "Advanced Spring MVC"
// lesson (which implemented MultipartFile by hand since that example was main-scope), here
// we're in test scope so we can use the real MockMultipartFile directly.
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
                "file",                          // part name matching the @RequestParam name
                "notes.txt",                      // original file name
                "text/plain",                     // content type
                "spring-mvc-testing notes".getBytes());

        // multipart(...): a special request builder that builds a multipart/form-data
        // body, instead of the usual get()/post().
        mockMvc.perform(multipart("/api/uploads").file(file))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.filename").value("notes.txt"))
                .andExpect(jsonPath("$.contentType").value("text/plain"))
                .andExpect(jsonPath("$.size").value(file.getSize()));

        System.out.println("Multipart file upload test passed.");

        // For scenarios like exceeding the size limit (see the "Multipart Size Limits"
        // section in the Advanced Spring MVC lesson), a @RestControllerAdvice that catches
        // MaxUploadSizeExceededException can be added, using the same pattern as in
        // ValidationErrorTestExample.
    }
}
