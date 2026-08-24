import org.springframework.core.MethodParameter;
import org.springframework.validation.BeanPropertyBindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;

// This is exactly what a failed @Valid produces for real, behind the
// scenes, when a @RequestBody's constraints don't pass: Spring throws a
// MethodArgumentNotValidException BEFORE the controller method ever runs,
// carrying a BindingResult with one FieldError per failed constraint.
class MethodArgumentNotValidExceptionExample {

    record CreateProductRequest(String name, int quantity) {
    }

    // A stand-in for the real controller method, used only so a real
    // MethodParameter can be constructed below -- in an actual failing
    // request, Spring builds this exception itself; it's built by hand
    // here just to show precisely what it contains.
    void create(CreateProductRequest request) {
    }

    public static void main(String[] args) throws NoSuchMethodException {
        var target = new CreateProductRequest("", -1);
        var bindingResult = new BeanPropertyBindingResult(target, "createProductRequest");
        bindingResult.addError(new FieldError("createProductRequest", "name", "must not be blank"));
        bindingResult.addError(new FieldError("createProductRequest", "quantity", "must be positive"));

        var method = MethodArgumentNotValidExceptionExample.class
                .getDeclaredMethod("create", CreateProductRequest.class);
        var parameter = new MethodParameter(method, 0);

        var exception = new MethodArgumentNotValidException(parameter, bindingResult);

        // getBindingResult().getFieldErrors() is how a handler reads each
        // individual failure -- exactly what a @RestControllerAdvice
        // method receiving this exception type would call.
        for (FieldError error : exception.getBindingResult().getFieldErrors()) {
            System.out.println(error.getField() + ": " + error.getDefaultMessage());
        }
        // name: must not be blank
        // quantity: must be positive
    }
}
