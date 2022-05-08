package su.boleyn.urlshortener;

import java.security.Principal;
import java.util.Collections;
import java.util.Set;

import org.apache.commons.codec.digest.DigestUtils;

import io.undertow.security.idm.Account;
import io.undertow.security.idm.Credential;
import io.undertow.security.idm.IdentityManager;
import io.undertow.security.idm.PasswordCredential;

public class PasswordIdentityManager implements IdentityManager {
	private String username;
	private String password;

	PasswordIdentityManager(String username, String password) {
		this.username = username;
		this.password = password;
	}

	@Override
	public Account verify(Account account) {
		return account;
	}

	@SuppressWarnings("serial")
	@Override
	public Account verify(String id, Credential credential) {
		if (credential instanceof PasswordCredential) {
			String password = new String(((PasswordCredential) credential).getPassword());
			String username = id;
			if (this.username.equals(username) && this.password.equals(DigestUtils.sha256Hex(password))) {
				return new Account() {
					private final Principal principal = new Principal() {
						@Override
						public String getName() {
							return username;
						}
					};

					@Override
					public Principal getPrincipal() {
						return principal;
					}

					@Override
					public Set<String> getRoles() {
						return Collections.emptySet();
					}
				};
			} else {
				return null;
			}
		} else {
			return null;
		}
	}

	@Override
	public Account verify(Credential credential) {
		return null;
	}

}
