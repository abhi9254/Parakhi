package org.abhi.parakhi;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;

import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.api.client.auth.oauth2.AuthorizationCodeFlow;
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

public class Oauth2Servlet extends AbstractAuthorizationCodeServlet {

	private static final long serialVersionUID = 1L;

	public final static HttpTransport HTTP_TRANSPORT = new NetHttpTransport();

	public final static JsonFactory JSON_FACTORY = new JacksonFactory();

	public final static List<String> SCOPES = Arrays.asList(SheetsScopes.SPREADSHEETS);

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String user = null;
		try {
			user = getUserId(request);
		} catch (ServletException e1) {
			e1.printStackTrace();
		}
		if (getCredential().getRefreshToken() != null)
			System.out.println("Refresh token for user '" + user + "' found in stored credentials");
		else
			System.out.println("Refresh token for user '" + user
					+ "' not found in stored credentials.Revoke access & delete the stored credentials.");
		System.out.print("Getting Access token: ");

		try {
			if (getCredential().refreshToken()) {
				System.out.println("Success");
				request.getSession().setAttribute("credential", getCredential());
				request.getSession().setAttribute("token", getCredential().getAccessToken());
			} else
				System.out.println("Failed");
		} catch (Exception e) {
			System.out.println(e);
		}
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

	public List<String> getWorksheets(String user_id, String token, String spreadsheetId) throws IOException {
		GoogleCredential cred = null;

		if (token != null)
			cred = new GoogleCredential().setAccessToken(token);

		try {
			// Build a new authorized API client service.
			Sheets service = new Sheets.Builder(Oauth2Servlet.HTTP_TRANSPORT, Oauth2Servlet.JSON_FACTORY, cred)
					.setApplicationName("Parakhi").build();

			Spreadsheet spreadsheet = service.spreadsheets().get(spreadsheetId).execute();
			List<Sheet> worksheets = spreadsheet.getSheets();

			List<String> worksheets_info = new ArrayList<String>(worksheets.size());
			for (Sheet worksheet : worksheets) {
				worksheets_info.add(worksheet.getProperties().getIndex(), worksheet.getProperties().getTitle());
			}
			return worksheets_info;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
}
