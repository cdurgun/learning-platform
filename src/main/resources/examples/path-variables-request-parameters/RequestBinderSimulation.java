import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;

import java.lang.reflect.Method;
import java.lang.reflect.Parameter;
import java.util.Map;

// Spring MVC Fundamentals' HandlerAdapter simulations could only invoke parameterless
// methods. This one does what a real HandlerAdapter's argument resolvers do: look at
// each parameter's annotation, pull the matching value out of the request, and pass it
// along when invoking the method.
class GreetingHandler {
    public String greet(@PathVariable("name") String name,
                         @RequestParam(defaultValue = "en") String lang,
                         @RequestHeader(value = "X-Client", required = false) String client) {
        return "Hello " + name + " (lang=" + lang + ", client=" + client + ")";
    }
}

class RequestBinderSimulation {

    static Object invoke(Object handler, Method method,
                          Map<String, String> pathVariables,
                          Map<String, String> queryParams,
                          Map<String, String> headers) throws Exception {
        Parameter[] parameters = method.getParameters();
        Object[] args = new Object[parameters.length];

        for (int i = 0; i < parameters.length; i++) {
            Parameter parameter = parameters[i];

            PathVariable pathVar = parameter.getAnnotation(PathVariable.class);
            if (pathVar != null) {
                args[i] = pathVariables.get(pathVar.value());
                continue;
            }

            RequestParam requestParam = parameter.getAnnotation(RequestParam.class);
            if (requestParam != null) {
                String value = queryParams.get(parameter.getName());
                args[i] = value != null ? value : requestParam.defaultValue();
                continue;
            }

            RequestHeader requestHeader = parameter.getAnnotation(RequestHeader.class);
            if (requestHeader != null) {
                args[i] = headers.get(requestHeader.value());
            }
        }

        return method.invoke(handler, args);
    }
}
