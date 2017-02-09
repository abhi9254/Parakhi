package org.abhi.parakhi;

import java.io.File;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import com.google.api.client.auth.oauth2.AuthorizationCodeFlow;
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.extensions.servlet.auth.oauth2.AbstractAuthorizationCodeServlet;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.services.sheets.v4.Sheets;
import com.google.api.services.sheets.v4.SheetsScopes;
import com.google.api.services.sheets.v4.model.Sheet;
import com.google.api.services.sheets.v4.model.Spreadsheet;
import org.abhi.parakhi.MySQL_dao;

public class Oauth2Servlet extends AbstractAuthorizationCodeServlet {

	// private final Logger log = Logger.getLogger(this.getClass());

	public final static HttpTransport HTTP_TRANSPORT = new NetHttpTransport();

	public final static JsonFactory JSON_FACTORY = new JacksonFactory();

	public final static List<String> SCOPES = Arrays.asList(SheetsScopes.SPREADSHEETS);

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

		// Credential cred = (Credential)
		// request.getServletContext().getAttribute("credential");
		// System.out.println("Current context cred token: " + cred);
		// System.out.println("Current context access token: "+
		// request.getAttribute("token"));
		getCredential().refreshToken();
		request.getServletContext().setAttribute("credential", getCredential());
		request.getServletContext().setAttribute("token", getCredential().getAccessToken());
		System.out.println("Auth success. Token: " + getCredential().getAccessToken());

		/**
		 * // File cred_file = new java.io.File(System.getProperty("user.home"),
		 * // ".credentials/sheets.googleapis.com-Parakhi/StoredCredential"); //
		 * System.out.println(cred_file.getName()); GoogleCredential cred =
		 * null;
		 * 
		 * if (request.getServletContext().getAttribute("token") != null) cred =
		 * new GoogleCredential().setAccessToken((String)
		 * request.getServletContext().getAttribute("token")); else { MySQL_dao
		 * ob = new MySQL_dao(); cred = new
		 * GoogleCredential().setAccessToken(ob.getUserToken(request.getSession(
		 * ).getId())); } System.out.println(
		 * "Creds loaded in context.Expire in " + cred.getExpiresInSeconds());
		 */
		response.sendRedirect(OauthCommon.SERVLET_CONTEXT + "/index.jsp");
	}

	@Override
	protected String getRedirectUri(HttpServletRequest req) throws ServletException, IOException {
		return OauthCommon.getRedirectUri(req);
	}

	@Override
	protected AuthorizationCodeFlow initializeFlow() throws IOException {
		return OauthCommon.initializeFlow();
	}

	@Override
	protected String getUserId(HttpServletRequest req) throws ServletException, IOException {
		return OauthCommon.getUserId(req);
	}

	public String getSheetTitle(String user_id, String token, String spreadsheetId) {
		GoogleCredential cred = null;

		if (token != null)
			cred = new GoogleCredential().setAccessToken(token);
		// cred = new GoogleCredential().setAccessToken(token)
		// else {
		// MySQL_dao ob = new MySQL_dao();
		// cred = new
		// GoogleCredential().setAccessToken(ob.getUserToken(user_id));
		// System.out.println("Context token is null. Fetched token from MySQL
		// for "+user_id);
		// }

		try {
			// System.out.println("In method getSheetTitle with context token "
			// + token + " for user " + user_id);
			Sheets service = new Sheets.Builder(Oauth2Servlet.HTTP_TRANSPORT, Oauth2Servlet.JSON_FACTORY, cred)
					.setApplicationName("Parakhi").build();
			Spreadsheet spreadsheet = service.spreadsheets().get(spreadsheetId).execute();
			String title = spreadsheet.getProperties().getTitle();
			// System.out.println(title);

			return title;
		} catch (Exception e) {
			e.printStackTrace();
			return e.toString();
		}
	}

	public List<String> getWorksheets(GoogleCredential credential, String spreadsheetId) throws IOException {
		// Build a new authorized API client service.
		Sheets service = new Sheets.Builder(Oauth2Servlet.HTTP_TRANSPORT, Oauth2Servlet.JSON_FACTORY, credential)
				.setApplicationName("Parakhi").build();

		Spreadsheet spreadsheet = service.spreadsheets().get(spreadsheetId).execute();
		List<Sheet> worksheets = spreadsheet.getSheets();

		List<String> worksheets_info = new ArrayList<String>(worksheets.size());
		for (Sheet worksheet : worksheets) {
			worksheets_info.add(worksheet.getProperties().getIndex(), worksheet.getProperties().getTitle());
		}
		return worksheets_info;
	}

}
