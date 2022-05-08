package su.boleyn.oj.core;

public class Config {
    protected static String getOrElse(String name, String defaultValue) {
        return System.getenv().getOrDefault(name, System.getProperty(name, defaultValue));
    }

    protected static String getOrFail(String name) {
        String ret = getOrElse(name, null);
        if (ret == null) {
            throw new RuntimeException(name + " must be set");
        }
        return ret;
    }
}
