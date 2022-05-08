package su.boleyn.urlshortener;

import java.util.Collections;

import io.undertow.security.api.AuthenticationMechanism;
import io.undertow.security.api.AuthenticationMode;
import io.undertow.security.handlers.AuthenticationCallHandler;
import io.undertow.security.handlers.AuthenticationConstraintHandler;
import io.undertow.security.handlers.AuthenticationMechanismsHandler;
import io.undertow.security.handlers.SecurityInitialHandler;
import io.undertow.security.idm.IdentityManager;
import io.undertow.security.impl.BasicAuthenticationMechanism;
import io.undertow.server.HttpHandler;
import io.undertow.server.HttpServerExchange;

class BasicAuthHandler implements HttpHandler {
	private HttpHandler next;

	public BasicAuthHandler(HttpHandler next, IdentityManager identityManager) {
		HttpHandler handler = next;
		handler = new AuthenticationCallHandler(handler);
		handler = new AuthenticationConstraintHandler(handler);
		handler = new AuthenticationMechanismsHandler(handler, Collections.<AuthenticationMechanism>singletonList(new BasicAuthenticationMechanism("su.boleyn.urlshortener")));
		handler = new SecurityInitialHandler(AuthenticationMode.PRO_ACTIVE, identityManager, handler);
		this.next = handler;
	}

	@Override
	public void handleRequest(HttpServerExchange exchange) throws Exception {
		next.handleRequest(exchange);
	}
}
