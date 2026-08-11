import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Map;
import java.util.function.Function;

// A miniature model of Spring's HttpMessageConverter chain: several converters, each
// claiming a media type, picked based on what the request/response needs -- the same
// idea behind both @RequestBody deserialization ("HttpMessageConverter: The Mechanism
// Behind @RequestBody/@ResponseBody") and content negotiation ("Content Negotiation:
// Choosing a Representation with Accept").
class MessageConverterSimulation {

    record Product(String name, double price) {
    }

    private final ObjectMapper jsonMapper = new ObjectMapper();

    private final Map<String, Function<Product, String>> writers = Map.of(
            "application/json", this::toJson,
            "application/xml", this::toXml
    );

    String write(Product product, String acceptHeader) {
        Function<Product, String> writer = writers.get(acceptHeader);
        if (writer == null) {
            return "406 Not Acceptable: " + acceptHeader;
        }
        return writer.apply(product);
    }

    Product read(String json) throws Exception {
        return jsonMapper.readValue(json, Product.class);
    }

    private String toJson(Product product) {
        try {
            return jsonMapper.writeValueAsString(product);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private String toXml(Product product) {
        return "<product><name>" + product.name() + "</name><price>" + product.price() + "</price></product>";
    }
}
