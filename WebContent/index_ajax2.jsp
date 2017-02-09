<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.regex.Matcher,java.util.regex.Pattern"%>
<%@ page import="org.abhi.parakhi.SheetsAPI"%>
<%@ page import="org.abhi.parakhi.Oauth2Servlet"%>
<%@ page import="org.abhi.parakhi.MySQL_dao"%>
<%@page
	import="com.google.api.client.googleapis.auth.oauth2.GoogleCredential"%>



<%
	PrintWriter outRes = response.getWriter();

	if (request.getParameter("trace_tbl_nm") != null && request.getParameter("src_tbl_nm") == null) {
		String tbl_nm = request.getParameter("trace_tbl_nm");
		MySQL_dao ob = new MySQL_dao();
		List<String> db_nms = new ArrayList<String>();
		db_nms = ob.traceTblNm_for_Src_Tbls(tbl_nm);
		for (int i = 0; i < db_nms.size(); i++) {
			outRes.print(db_nms.get(i));
			if (i != db_nms.size() - 1)
				outRes.print(",");
		}
	}
	if (request.getParameter("trace_tbl_nm") != null && request.getParameter("src_tbl_nm") != null) {
		
		String trace_tbl_nm = request.getParameter("trace_tbl_nm");
		String src_tbl_nm = request.getParameter("src_tbl_nm");
		MySQL_dao ob = new MySQL_dao();
		List<String> col_nms = new ArrayList<String>();
		col_nms = ob.traceTblNm_for_Src_Cols(trace_tbl_nm, src_tbl_nm);
		for (int i = 0; i < col_nms.size(); i++) {
			outRes.print(col_nms.get(i));
			if (i != col_nms.size() - 1)
				outRes.print(",");
		}
	}

	if (request.getParameter("connection_url") != null && request.getParameter("user") != null
			&& request.getParameter("pwd") != null) {
		String DB_URL = request.getParameter("connection_url");
		String USER = request.getParameter("user");
		String PASS = request.getParameter("pwd");
		try {
			Connection conn = null;
			Class.forName("com.mysql.jdbc.Driver");

			conn = DriverManager.getConnection(DB_URL, USER, PASS);

			PreparedStatement preparedStatement = conn.prepareStatement("show databases");
			ResultSet rs = preparedStatement.executeQuery();
			if (rs.next()) {
				outRes.print("Success");
			}
			conn.close();
		} catch (Exception ex) {
			outRes.println("Error: " + ex.toString());
			ex.printStackTrace();
		}

	}
	if (request.getParameter("hive_connection_url") != null && request.getParameter("hive_user") != null
			&& request.getParameter("hive_pwd") != null) {
		String DB_URL = request.getParameter("hive_connection_url");
		String USER = request.getParameter("hive_user");
		String PASS = request.getParameter("hive_pwd");
		try {

			Class.forName("org.apache.hive.jdbc.HiveDriver");
			Connection con = DriverManager.getConnection(DB_URL, USER, PASS);
			Statement stmt = con.createStatement();
			String query = "show databases";

			ResultSet res = stmt.executeQuery(query);
			if (res.next()) {
				outRes.print("Success");
			}
		} catch (Exception ex) {
			outRes.println("Error: " + ex.toString());
			ex.printStackTrace();
		}

	}

	if (request.getParameter("proj_id") != null) {
		int p_id = Integer.parseInt(request.getParameter("proj_id"));
		MySQL_dao ob = new MySQL_dao();
		List<String> db_list = new ArrayList<String>(ob.getProjDbNames(p_id));

		for (String db : db_list) {
			outRes.println(db + "<br>");
			String[] tables = ob.getDbTblNames(Integer.parseInt(request.getParameter("proj_id")), db);

			for (int i = 0; i < tables.length; i++) {
				outRes.println("Table: " + tables[i] + ", Frequency: daily <br>");

			}
		}
	}

	if (request.getParameter("spreadsheet_id") != null && !request.getParameter("spreadsheet_id").equals("")) {
		Pattern p = Pattern.compile("spreadsheets/d/.*/");
		Matcher m = p.matcher(request.getParameter("spreadsheet_id"));
		String stm_sheet_id;
		String stm_title;

		if (m.find()) {
			stm_sheet_id = m.group().substring(15, m.group().length() - 1);
			//	SheetsAPI ob = new SheetsAPI();
			Oauth2Servlet ob2 = new Oauth2Servlet();
			try {
				stm_title = ob2.getSheetTitle(request.getSession().getAttribute("user_id").toString(),
						(String) request.getServletContext().getAttribute("token"), stm_sheet_id);
				//	stm_title = ob.getSheetTitle(stm_sheet_id);
				outRes.println("<br>Found Spreadsheet: " + stm_title + "<br><br>");

				//		List<String> ws = new ArrayList<String>(ob2.getWorksheets((GoogleCredential)request.getServletContext().getAttribute("credential"),stm_sheet_id));
				//		outRes.println("Select worksheets to import: <br>");
				//		for (String s : ws) {
				//			outRes.println("<input type='checkbox' name='ws' value='" + s + "'> " + s);
				//			int[] last_row_col = ob.getLastRowCol(stm_sheet_id, s);
				//			outRes.println("/ Last row: " + last_row_col[0] + "," + last_row_col[1]);
				//		}
			} catch (Exception ex) {
				outRes.println("Error in fetching title. " + ex.toString());

			}

		} else {
			outRes.print("Cannot parse url. Please enter a valid Google Spreadsheet link");
		}
	}
%>