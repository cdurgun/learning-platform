import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;

// multipart/form-data is the content type browsers use for file uploads -- unlike
// @RequestBody (which reads one JSON body via a single HttpMessageConverter), a
// multipart request is split into named parts, and MultipartFile binds one of them
// straight to a controller parameter, the same way @RequestParam binds a plain form
// field (see Path Variable'lar ve Request Parametreleri).
@RestController
class MultipartUploadControllerExample {

    @PostMapping("/upload")
    public String upload(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return "empty file";
        }
        return "received " + file.getOriginalFilename() + " (" + file.getSize() + " bytes)";
    }

    // A minimal hand-written MultipartFile, standing in for the real implementation
    // Spring builds from the actual HTTP request -- just enough to exercise upload()
    // without a servlet container.
    static class InMemoryMultipartFile implements MultipartFile {
        private final String originalFilename;
        private final byte[] content;

        InMemoryMultipartFile(String originalFilename, byte[] content) {
            this.originalFilename = originalFilename;
            this.content = content;
        }

        public String getName() {
            return "file";
        }

        public String getOriginalFilename() {
            return originalFilename;
        }

        public String getContentType() {
            return "text/plain";
        }

        public boolean isEmpty() {
            return content.length == 0;
        }

        public long getSize() {
            return content.length;
        }

        public byte[] getBytes() {
            return content;
        }

        public InputStream getInputStream() {
            return new ByteArrayInputStream(content);
        }

        public void transferTo(File dest) throws IOException, IllegalStateException {
            throw new UnsupportedOperationException("not needed for this example");
        }
    }

    public static void main(String[] args) {
        MultipartUploadControllerExample controller = new MultipartUploadControllerExample();

        System.out.println(controller.upload(new InMemoryMultipartFile("notes.txt", "hello".getBytes())));
        // received notes.txt (5 bytes)

        System.out.println(controller.upload(new InMemoryMultipartFile("empty.txt", new byte[0])));
        // empty file
    }
}
