import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.List;

// @RequestBody isn't limited to flat objects -- Jackson recursively deserializes
// nested objects and lists, as long as every level has a matching Java type.
class NestedObjectDeserializationExample {

    record Address(String city, String country) {
    }

    record OrderRequest(String customerName, Address shippingAddress, List<String> items) {
    }

    public static void main(String[] args) throws Exception {
        ObjectMapper mapper = new ObjectMapper();

        String json = """
                {
                  "customerName": "Ayse",
                  "shippingAddress": { "city": "Istanbul", "country": "Turkey" },
                  "items": ["Keyboard", "Mouse"]
                }
                """;

        OrderRequest order = mapper.readValue(json, OrderRequest.class);
        System.out.println(order);
        // OrderRequest[customerName=Ayse, shippingAddress=Address[city=Istanbul, country=Turkey], items=[Keyboard, Mouse]]
    }
}
