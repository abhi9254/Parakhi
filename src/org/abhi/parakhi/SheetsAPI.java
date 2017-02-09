package org.abhi.parakhi;

import com.google.api.client.auth.oauth2.AuthorizationCodeRequestUrl;
import com.google.api.client.auth.oauth2.AuthorizationCodeTokenRequest;
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.extensions.java6.auth.oauth2.AuthorizationCodeInstalledApp;
import com.google.api.client.extensions.jetty.auth.oauth2.LocalServerReceiver;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeRequestUrl;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.util.store.FileDataStoreFactory;
import com.google.api.services.sheets.v4.SheetsScopes;
import com.google.api.services.sheets.v4.model.*;
import com.google.api.services.sheets.v4.Sheets;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.hive.jdbc.HiveResultSetMetaData;
import org.apache.hive.jdbc.HiveStatement;

public class SheetsAPI{

	private static final String APPLICATION_NAME = "Parakhi";
	private static final java.io.File DATA_STORE_DIR = new java.io.File(System.getProperty("user.home"),
			".credentials/sheets.googleapis.com-Parakhi");

	private static FileDataStoreFactory DATA_STORE_FACTORY;
	private static final JsonFactory JSON_FACTORY = JacksonFactory.getDefaultInstance();

	private static HttpTransport HTTP_TRANSPORT;
	private static final List<String> SCOPES = Arrays.asList(SheetsScopes.SPREADSHEETS);

	static {
		try {
			HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
			DATA_STORE_FACTORY = new FileDataStoreFactory(DATA_STORE_DIR);
		} catch (Throwable t) {
			t.printStackTrace();
			System.exit(1);
		}
	}

	public static Credential authorize() throws IOException {
		// Load client secrets.
		InputStream in = SheetsAPI.class.getResourceAsStream("client_secret.json");
		GoogleClientSecrets clientSecrets = GoogleClientSecrets.load(JSON_FACTORY, new InputStreamReader(in));

		// Build flow and trigger user authorization request.
		GoogleAuthorizationCodeFlow flow = new GoogleAuthorizationCodeFlow.Builder(HTTP_TRANSPORT, JSON_FACTORY,
				clientSecrets, SCOPES).setDataStoreFactory(DATA_STORE_FACTORY).setAccessType("offline")
						.setApprovalPrompt("force").build();
		//LocalServerReceiver lsr = new LocalServerReceiver();
		//LocalServerReceiver lsr = new LocalServerReceiver.Builder().setHost("mydomain.do/Parakhi").setPort(8080).build();
		AuthorizationCodeRequestUrl authorizationUrl = flow.newAuthorizationUrl();
		authorizationUrl.setRedirectUri("http://localhost:8080/Parakhi/getAuthCode");
		
		System.out.println(authorizationUrl.build().toString());
		//System.out.println(lsr.getRedirectUri());
		//Credential credential = new AuthorizationCodeInstalledApp(flow, lsr).authorize("user");

		//System.out.println("Credentials saved to " + DATA_STORE_DIR.getAbsolutePath());
		//return credential;
		return null;
	}


	public static Sheets getSheetsService() throws IOException {
		Credential credential = authorize();
		return new Sheets.Builder(HTTP_TRANSPORT, JSON_FACTORY, credential).setApplicationName(APPLICATION_NAME)
				.build();
	}

	public String getSheetTitle(String spreadsheetId) throws IOException {
		// Build a new authorized API client service.
		Sheets service = getSheetsService();

		Spreadsheet spreadsheet = service.spreadsheets().get(spreadsheetId).execute();
		String title = spreadsheet.getProperties().getTitle();
		return title;
	}

	public List<String> getWorksheets(String spreadsheetId) throws IOException {
		// Build a new authorized API client service.
		Sheets service = getSheetsService();
		Spreadsheet spreadsheet = service.spreadsheets().get(spreadsheetId).execute();
		List<Sheet> worksheets = spreadsheet.getSheets();

		List<String> worksheets_info = new ArrayList<String>(worksheets.size());
		for (Sheet worksheet : worksheets) {
			worksheets_info.add(worksheet.getProperties().getIndex(), worksheet.getProperties().getTitle());
		}
		return worksheets_info;
	}

	public int[] getLastRowCol(String spreadsheetId, String worksheet_nm) {
		// Build a new authorized API client service.
		int[] last_row_col = new int[2];

		try {
			Sheets service = getSheetsService();
			Spreadsheet spreadsheet = service.spreadsheets().get(spreadsheetId).execute();
			List<Sheet> worksheets = spreadsheet.getSheets();
			int last_row = 0;
			int last_col = 0;
			for (Sheet worksheet : worksheets) {
				String ws_title = worksheet.getProperties().getTitle();
				// System.out.println("Entered for loop with *" + worksheet_nm +
				// "* and *" + ws_title + "*");
				if (worksheet_nm.equals(ws_title)) {
					List<List<String>> data = readSheetData(spreadsheetId, ws_title + "!A1:P");
					last_row = data.size();
					for (List<String> row : data) {
						int last_cell = row.size();
						if (last_cell > last_col)
							last_col = last_cell;
					}
				}
			}
			last_row_col[0] = last_row;
			last_row_col[1] = last_col;
			return last_row_col;
		}

		catch (Exception ex) {
			System.out.println(ex.toString());
			return last_row_col;
		}
	}

	public List<List<String>> readSheetData(String spreadsheetId, String range) throws IOException {
		// Build a new authorized API client service.
		Sheets service = getSheetsService();

		ValueRange readResponse = service.spreadsheets().values().get(spreadsheetId, range).execute();
		List<List<Object>> readOutput = readResponse.getValues();
		List<List<String>> readOutput_ = new ArrayList<List<String>>();
		if (readOutput == null || readOutput.size() == 0) {
			System.out.println("No data found.");
		} else {
			for (List<Object> row : readOutput) {
				List<String> row_content = new ArrayList<String>();
				for (int i = 0; i < row.size(); i++)
					row_content.add(row.get(i).toString());
				readOutput_.add(row_content);
			}
		}

		return readOutput_;
	}

	public int writeSheetData(List<List<Object>> writedata, String spreadsheetId, String majorDimension, String range)
			throws IOException {
		// Build a new authorized API client service.
		Sheets service = getSheetsService();

		ValueRange vr = new ValueRange().setValues(writedata).setMajorDimension(majorDimension);
		UpdateValuesResponse upd_res = service.spreadsheets().values().update(spreadsheetId, range, vr)
				.setValueInputOption("RAW").execute();
		return upd_res.getUpdatedCells();
	}

	public List<List<Object>> execHiveQueries(List<List<String>> queries) {

		List<List<Object>> results = new ArrayList<List<Object>>();
		List<Object> result = new ArrayList<Object>();

		String driverName = "org.apache.hive.jdbc.HiveDriver";

		try {
			Class.forName(driverName);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		try {
			Connection con = DriverManager.getConnection("jdbc:hive2://localhost:10000/default", "hive", "");
			HiveStatement stmt = (HiveStatement) con.createStatement();

			for (List<String> row : queries) {
				String query = row.get(0);
				ResultSet res = stmt.executeQuery(query);
				HiveResultSetMetaData rsmd = (HiveResultSetMetaData) res.getMetaData();
				int columnsNumber = rsmd.getColumnCount();
				int dot_pos = rsmd.getColumnName(1).indexOf(".") + 1;

				StringBuilder op = new StringBuilder("\n ");
				for (int i = 1; i <= columnsNumber; i++) {
					op.append("\t" + rsmd.getColumnName(i).substring(dot_pos));
				}

				while (res.next()) {
					op.append("\n");
					op.append(res.getRow());
					for (int c = 1; c <= columnsNumber; c++) {
						op.append("\t" + res.getString(c));
					}
				}
				result.add(op.toString());
				res.close();
			}

			stmt.close();
			con.close();

			results.add(result);

		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return results;
	}

	public void rerunSheet(String spreadsheetId, String queries_range, String output_range) throws IOException {

		List<List<String>> queries = readSheetData(spreadsheetId, queries_range);
		writeSheetData(execHiveQueries(queries), spreadsheetId, "COLUMNS", output_range);
	}

}
