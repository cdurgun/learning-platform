import org.springframework.core.convert.ConversionException;
import org.springframework.core.convert.support.DefaultConversionService;

// Every @PathVariable/@RequestParam value arrives as a String -- Spring converts it to
// the declared parameter type (Long, int, boolean...) using the same kind of
// ConversionService machinery shown here directly. When conversion fails, real Spring
// MVC turns it into a 400 Bad Request before your controller method is ever called.
class TypeConversionErrorExample {
    public static void main(String[] args) {
        DefaultConversionService conversionService = new DefaultConversionService();

        Long id = conversionService.convert("42", Long.class);
        System.out.println("Converted: " + id);
        // Converted: 42

        try {
            conversionService.convert("abc", Long.class);
        } catch (ConversionException e) {
            System.out.println("Conversion failed, just like a real request to /products/abc would fail");
            // Conversion failed, just like a real request to /products/abc would fail
        }
    }
}
