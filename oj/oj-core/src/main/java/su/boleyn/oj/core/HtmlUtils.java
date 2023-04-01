package su.boleyn.oj.core;

import org.apache.commons.text.StringEscapeUtils;
import org.owasp.html.HtmlPolicyBuilder;
import org.owasp.html.PolicyFactory;
import org.owasp.html.Sanitizers;

public class HtmlUtils extends Config {
    private static final PolicyFactory policy = new HtmlPolicyBuilder()
            .allowElements("pre")
            .toFactory()
            .and(Sanitizers.FORMATTING).and(Sanitizers.LINKS).and(Sanitizers.BLOCKS)
            .and(Sanitizers.IMAGES).and(Sanitizers.STYLES).and(Sanitizers.TABLES);

    public static String sanitize(String html) {
        return policy.sanitize(html);
    }

    public static String sanitizeTextContent(String attribute) {
        return StringEscapeUtils.escapeHtml4(attribute);
    }

    public static String sanitizeAttribute(String attribute) {
        return StringEscapeUtils.escapeHtml4(attribute);
    }
}
