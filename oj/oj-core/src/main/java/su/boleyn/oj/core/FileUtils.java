package su.boleyn.oj.core;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;

public class FileUtils extends Config {
    private static final String DATA_PATH = getOrFail("DATA");

    public static String read(String path) throws IOException {
        BufferedReader reader = new BufferedReader(
                new InputStreamReader(new FileInputStream(DATA_PATH + path), "utf-8"));
        StringBuffer data = new StringBuffer();
        char[] buffer = new char[1024];
        int length;
        while ((length = reader.read(buffer)) != -1) {
            data.append(String.valueOf(buffer, 0, length));
        }
        reader.close();
        return data.toString();
    }

}
