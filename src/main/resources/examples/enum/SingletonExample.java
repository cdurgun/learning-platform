enum ConfigurationManager {
    INSTANCE;

    private String environment = "production";

    public String getEnvironment() {
        return environment;
    }

    public void setEnvironment(String environment) {
        this.environment = environment;
    }
}
