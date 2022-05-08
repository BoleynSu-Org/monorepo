package su.boleyn.urlshortener;

import java.util.concurrent.locks.Lock;

import io.undertow.server.HttpHandler;
import io.undertow.server.HttpServerExchange;

public class LockHandler implements HttpHandler {
	private Lock lock;
	private HttpHandler next;

	public LockHandler(Lock lock, HttpHandler next) {
		this.lock = lock;
		this.next = next;
	}

	@Override
	public void handleRequest(HttpServerExchange exchange) throws Exception {
		lock.lock();
		try {
			next.handleRequest(exchange);
		} finally {
			lock.unlock();
		}
	}
}
