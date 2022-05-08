package su.boleyn.urlshortener;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

import org.apache.commons.validator.routines.UrlValidator;

import io.undertow.Handlers;
import io.undertow.Undertow;
import io.undertow.security.idm.IdentityManager;
import io.undertow.server.HttpHandler;
import io.undertow.server.HttpServerExchange;
import io.undertow.server.handlers.CookieImpl;
import io.undertow.server.handlers.ExceptionHandler;
import io.undertow.server.session.SecureRandomSessionIdGenerator;
import io.undertow.util.Headers;

public class URLShortenerServer {
	private ReadWriteLock lock;
	private URLShortener shortener;
	private IdentityManager identityManager;
	private SecureRandomSessionIdGenerator tokenGenerator;
	private Undertow server;

	private HttpHandler addBasicAuth(HttpHandler next) {
		return new BasicAuthHandler(next, identityManager);
	}

	private HttpHandler addReadLock(HttpHandler next) {
		return new LockHandler(lock.readLock(), next);
	}

	private HttpHandler addWriteLock(HttpHandler next) {
		return new LockHandler(lock.writeLock(), next);
	}

	public URLShortenerServer(String db, int port, String host, String username, String password) {

		try {
			lock = new ReentrantReadWriteLock();

			shortener = new URLShortener(db);

			identityManager = new PasswordIdentityManager(username, password);

			tokenGenerator = new SecureRandomSessionIdGenerator();

			server = Undertow.builder().addHttpListener(port, host).setHandler(
					Handlers.exceptionHandler(Handlers.path().addPrefixPath("/", addReadLock(new HttpHandler() {
						@Override
						public void handleRequest(final HttpServerExchange exchange) throws Exception {
							String code = exchange.getRelativePath();
							String url = shortener.getURL(code);
							if (url == null) {
								exchange.setStatusCode(404);
								exchange.getResponseHeaders().put(Headers.CONTENT_TYPE, "text/plain");
								exchange.getResponseSender().send("404 Not Found");
							} else {
								exchange.setStatusCode(302);
								exchange.getResponseHeaders().put(Headers.LOCATION, url);
							}
						}
					})).addPrefixPath("/history", addBasicAuth(addReadLock(new HttpHandler() {
						@Override
						public void handleRequest(final HttpServerExchange exchange) throws Exception {
							String code = exchange.getRelativePath();
							ArrayList<URLInfo> history = shortener.getHistory(code);
							if (history == null) {
								exchange.setStatusCode(404);
								exchange.getResponseHeaders().put(Headers.CONTENT_TYPE, "text/plain");
								exchange.getResponseSender().send("404 Not Found");
							} else {
								exchange.setStatusCode(200);
								exchange.getResponseHeaders().put(Headers.CONTENT_TYPE, "text/plain; charset=UTF-8");
								StringBuffer sb = new StringBuffer();
								sb.append("code: " + code + "\n\n\n");
								for (URLInfo info : history) {
									sb.append("url: " + info.url + "\n");
									sb.append("createdAt: " + info.createdAt + "\n");
									sb.append("expiresAt: " + info.expiresAt + "\n\n");
								}
								exchange.getResponseSender().send(sb.toString());
							}
						}
					}))).addPrefixPath("/list", addBasicAuth(addReadLock(new HttpHandler() {
						@Override
						public void handleRequest(final HttpServerExchange exchange) throws Exception {
							exchange.setStatusCode(200);
							exchange.getResponseHeaders().put(Headers.CONTENT_TYPE, "text/plain; charset=UTF-8");
							Map<String, String> list = shortener.getAll();
							StringBuffer sb = new StringBuffer();
							for (Entry<String, String> entry : list.entrySet()) {
								sb.append(entry.getKey() + " -> " + entry.getValue() + "\n");
							}
							exchange.getResponseSender().send(sb.toString());
						}
					}))).addPrefixPath("/create", addBasicAuth(addWriteLock(new HttpHandler() {
						@Override
						public void handleRequest(final HttpServerExchange exchange) throws Exception {
							String code = exchange.getRelativePath();

							String url;
							if (exchange.getQueryParameters().get("url") != null && UrlValidator.getInstance()
									.isValid(exchange.getQueryParameters().get("url").getLast())) {
								url = exchange.getQueryParameters().get("url").getLast();
							} else {
								exchange.setStatusCode(400);
								exchange.getResponseHeaders().put(Headers.CONTENT_TYPE, "text/plain");
								exchange.getResponseSender().send("400 Bad Request ");
								return;
							}

							Date createdAt = new Date();
							Date expiresAt;
							if (exchange.getQueryParameters().get("month") != null) {
								Calendar c = Calendar.getInstance();
								c.setTime(createdAt);
								c.add(Calendar.MONTH, 1);
								expiresAt = c.getTime();
							} else if (exchange.getQueryParameters().get("week") != null) {
								Calendar c = Calendar.getInstance();
								c.setTime(createdAt);
								c.add(Calendar.WEEK_OF_YEAR, 1);
								expiresAt = c.getTime();
							} else if (exchange.getQueryParameters().get("day") != null) {
								Calendar c = Calendar.getInstance();
								c.setTime(createdAt);
								c.add(Calendar.DATE, 1);
								expiresAt = c.getTime();
							} else if (exchange.getQueryParameters().get("expires_after") != null) {
								Calendar c = Calendar.getInstance();
								c.setTime(createdAt);
								try {
									c.add(Calendar.SECOND, Integer
											.parseInt(exchange.getQueryParameters().get("expires_after").getLast()));
								} catch (Exception e) {
									exchange.setStatusCode(400);
									exchange.getResponseHeaders().put(Headers.CONTENT_TYPE, "text/plain");
									exchange.getResponseSender().send("400 Bad Request ");
									return;
								}
								expiresAt = c.getTime();
							} else {
								expiresAt = null;
							}

							if (exchange.getQueryParameters().get("token") == null || exchange.getRequestCookie("token") == null || !exchange.getQueryParameters().get("token").getLast().equals(exchange.getRequestCookie("token").getValue())) {
								String token = tokenGenerator.createSessionId();
								exchange.setStatusCode(200);
								exchange.getResponseHeaders().put(Headers.CONTENT_TYPE, "text/html");
								exchange.getResponseHeaders().put(Headers.X_FRAME_OPTIONS, "deny");
								exchange.setResponseCookie(new CookieImpl("token", token));
								exchange.getResponseSender().send("<!DOCTYPE html><title>Confirm</title><a href='" + exchange.getRequestURI() + "?" + exchange.getQueryString() + "&token=" + token + "'>Confirm</a>");
								return;
							}

							URLInfo info = new URLInfo();
							info.code = code;
							info.url = url;
							info.createdAt = createdAt;
							info.expiresAt = expiresAt;

							shortener.shorten(info);

							exchange.setStatusCode(200);
							exchange.getResponseHeaders().put(Headers.CONTENT_TYPE, "text/plain; charset=UTF-8");
							StringBuffer sb = new StringBuffer();
							sb.append("code: " + code + "\n\n\n");
							sb.append("url: " + info.url + "\n");
							sb.append("createdAt: " + info.createdAt + "\n");
							sb.append("expiresAt: " + info.expiresAt + "\n\n");
							exchange.getResponseSender().send(sb.toString());
						}
					})))).addExceptionHandler(Exception.class, new HttpHandler() {
						@Override
						public void handleRequest(HttpServerExchange exchange) throws Exception {
							exchange.setStatusCode(500);
							exchange.getResponseHeaders().put(Headers.CONTENT_TYPE, "text/plain");
							exchange.getResponseSender().send("500 Internal Server Error");
							exchange.getAttachment(ExceptionHandler.THROWABLE).printStackTrace();
						}
					})).build();
		} catch (Exception e) {
			throw new RuntimeException("failed to start the server", e);
		}
	}

	public void start() {
		server.start();
	}

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

	public static void main(final String[] args) {
		new URLShortenerServer(
				getOrElse("DB", "urlshortener.db"),
				Integer.parseInt(getOrElse("PORT", "8080")),
				getOrElse("HOST", "localhost"),
				getOrFail("URLSHORTENER_USERNAME"),
				getOrFail("URLSHORTENER_PASSWORD")).start();
	}
}
