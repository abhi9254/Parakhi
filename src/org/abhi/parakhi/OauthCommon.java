package org.abhi.parakhi;

import java.io.IOException;
import java.util.Collection;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import com.google.api.client.auth.oauth2.AuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.GenericUrl;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.util.store.FileDataStoreFactory;

public class OauthCommon {

	public final static String SERVLET_CONTEXT = "/Parakhi";
	public final static String OAUTH_CALLBACK_PATH = "/Oauth2ServletCallback";
	public final static String OAUTH_PATH = "/oauth";
	public final static String CALL_BACK_URI = SERVLET_CONTEXT + OAUTH_CALLBACK_PATH;
	public final static String OAUTH_URI = SERVLET_CONTEXT + OAUTH_PATH;
	private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();
	private static HttpTransport HTTP_TRANSPORT;
	private static final java.io.File DATA_STORE_DIR = new java.io.File(System.getProperty("user.home"),
			".credentials/sheets.googleapis.com-Parakhi");

	private static FileDataStoreFactory DATA_STORE_FACTORY;
	static {
		try {
			HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
			DATA_STORE_FACTORY = new FileDataStoreFactory(DATA_STORE_DIR);
		} catch (Throwable t) {
			t.printStackTrace();
			System.exit(1);
		}
	}

	protected static String getRedirectUri(HttpServletRequest req) throws ServletException, IOException {
		GenericUrl url = new GenericUrl(req.getRequestURL().toString());
		url.setRawPath(CALL_BACK_URI);
		return url.build();
	}

	public static AuthorizationCodeFlow initializeFlow() throws IOException {

		return new GoogleAuthorizationCodeFlow.Builder(HTTP_TRANSPORT, JSON_FACTORY,
				"516645433666-ltekci2vg1n9e52og7kk5vjv2hp0450f.apps.googleusercontent.com", "LqGK_f18XOKVADCOBWWWuZgx",
				Oauth2Servlet.SCOPES).setDataStoreFactory(DATA_STORE_FACTORY).setAccessType("offline").build();
	}

	public static String getUserId(HttpServletRequest req) throws ServletException, IOException {
		String id;
		String current_user = (String) req.getSession().getAttribute("user_id");
		if (current_user != null)
			id = current_user;
		else
			id = req.getSession().getId();
		return id;
	}
}
