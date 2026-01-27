package config;

import java.io.InputStream;
import java.util.Properties;

public class SecretConfig {

    private static Properties props = new Properties();

    static {
        try {
            InputStream is = SecretConfig.class
                .getClassLoader()
                .getResourceAsStream("config/secret2.properties");

            if (is == null) {
                throw new RuntimeException("secret2.properties not found");
            }

            props.load(is);
            is.close();

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static String get(String key) {
        return props.getProperty(key);
    }
}