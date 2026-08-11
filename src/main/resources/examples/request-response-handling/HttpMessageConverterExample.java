import com.fasterxml.jackson.databind.ObjectMapper;

// @RequestBody and @ResponseBody don't do the JSON conversion themselves -- they
// delegate to an HttpMessageConverter, and for JSON that converter is backed by
// exactly the Jackson ObjectMapper used directly here. spring-boot-starter-web
// auto-configures one of these and registers it as a bean; this is what it does
// under the hood on every request/response.
class HttpMessageConverterExample {

    record Product(String name, double price) {
    }

    public static void main(String[] args) throws Exception {
        ObjectMapper mapper = new ObjectMapper();

        // What happens to an incoming @RequestBody:
        String requestJson = "{\"name\":\"Keyboard\",\"price\":49.9}";
        Product product = mapper.readValue(requestJson, Product.class);
        System.out.println(product);
        // Product[name=Keyboard, price=49.9]

        // What happens to an outgoing @ResponseBody:
        String responseJson = mapper.writeValueAsString(product);
        System.out.println(responseJson);
        // {"name":"Keyboard","price":49.9}
    }
}
