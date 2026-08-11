import org.springframework.ui.ExtendedModelMap;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.servlet.ModelAndView;

// Three ways to hand data to a view. All three end up as the same thing under the
// hood -- a String-keyed map the view engine reads from -- but they differ in how
// (and where) you populate that map.
class ModelVariantsExample {

    // 1) Model: the interface you see most often as a controller method parameter.
    //    DispatcherServlet creates and injects it automatically (see the Spring MVC
    //    Fundamentals lesson's "Model: Controller'dan View'a Veri Taşımak" section).
    static Model buildWithModel() {
        Model model = new ExtendedModelMap();
        model.addAttribute("title", "Spring MVC Views & Thymeleaf");
        model.addAttribute("readingMinutes", 20);
        return model;
    }

    // 2) ModelMap: Model actually extends ModelMap -- Model just narrows the API down
    //    to addAttribute(...). ModelMap also exposes plain java.util.Map methods.
    static ModelMap buildWithModelMap() {
        ModelMap modelMap = new ModelMap();
        modelMap.addAttribute("title", "Spring MVC Views & Thymeleaf");
        modelMap.put("readingMinutes", 20);
        return modelMap;
    }

    // 3) ModelAndView: bundles the model AND the view name into a single object --
    //    an alternative to returning a String view name and taking Model as a
    //    parameter. Useful when the view name itself depends on some computation
    //    that happens after the model is already partly built.
    static ModelAndView buildWithModelAndView() {
        ModelAndView mav = new ModelAndView("topic");
        mav.addObject("title", "Spring MVC Views & Thymeleaf");
        mav.addObject("readingMinutes", 20);
        return mav;
    }

    public static void main(String[] args) {
        Model model = buildWithModel();
        System.out.println(model.asMap());
        // {title=Spring MVC Views & Thymeleaf, readingMinutes=20}

        ModelMap modelMap = buildWithModelMap();
        System.out.println(modelMap);
        // {title=Spring MVC Views & Thymeleaf, readingMinutes=20}

        ModelAndView mav = buildWithModelAndView();
        System.out.println(mav.getViewName() + " -> " + mav.getModel());
        // topic -> {title=Spring MVC Views & Thymeleaf, readingMinutes=20}
    }
}
