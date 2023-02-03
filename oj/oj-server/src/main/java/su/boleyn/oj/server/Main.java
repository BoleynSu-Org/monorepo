package su.boleyn.oj.server;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.nio.file.Paths;
import java.util.Enumeration;
import java.util.zip.ZipFile;
import java.util.zip.ZipEntry;

import org.apache.catalina.connector.Connector;
import org.apache.catalina.startup.Tomcat;
import org.apache.commons.io.IOUtils;

import su.boleyn.oj.core.Config;

public class Main extends Config {
    static final String ADDRESS = getOrElse("ADDRESS", "0.0.0.0");
    static final int PORT = Integer.parseInt(getOrElse("PORT", "8080"));
    static final String WEBAPP = getOrElse("WEBAPP", "main/webapp");

    public static void main(String[] args) throws Exception {
        Tomcat tomcat = new Tomcat();
        Connector connector = new Connector();
        connector.setProperty("address", ADDRESS);
        connector.setPort(PORT);
        tomcat.setConnector(connector);
        try (ZipFile zipFile = new ZipFile(
                Paths.get(Main.class.getProtectionDomain().getCodeSource().getLocation().toURI()).toFile())) {
            Enumeration<? extends ZipEntry> entries = zipFile.entries();
            while (entries.hasMoreElements()) {
                ZipEntry entry = entries.nextElement();
                String name = entry.getName();
                if (name.startsWith(WEBAPP)) {
                    File file = new File(name);
                    if (entry.isDirectory()) {
                        file.mkdirs();
                    } else {
                        file.getParentFile().mkdirs();
                        try (InputStream in = zipFile.getInputStream(entry);
                                OutputStream out = new FileOutputStream(file)) {
                            IOUtils.copy(in, out);
                        }
                    }
                }
            }
        }
        tomcat.addWebapp("", new File(WEBAPP).getAbsolutePath());
        tomcat.start();
        tomcat.getServer().await();
    }
}
