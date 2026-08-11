import org.springframework.web.bind.annotation.RequestMethod;

class RouterWithMethodDemo {
    public static void main(String[] args) {
        RouterWithMethodSimulation router = new RouterWithMethodSimulation();
        router.register(new ArticleApiHandlers());
        router.register(new CommentApiHandlers());

        System.out.println(router.dispatch("/articles", RequestMethod.GET));
        // Listing articles
        System.out.println(router.dispatch("/articles", RequestMethod.POST));
        // Creating an article
        System.out.println(router.dispatch("/articles", RequestMethod.DELETE));
        // 405 Method Not Allowed: DELETE /articles
        System.out.println(router.dispatch("/comments", RequestMethod.DELETE));
        // Deleting all comments
    }
}
