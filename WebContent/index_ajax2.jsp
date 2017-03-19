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

	if (request.getParameter("spreadsheet_id") != null && !request.getParameter("spreadsheet_id").equals("")
			&& request.getParameter("title") != null) {
		Pattern p = Pattern.compile("spreadsheets/d/.*/");
		Matcher m = p.matcher(request.getParameter("spreadsheet_id"));
		String stm_sheet_id;
		String stm_title;

		if (m.find()) {
			stm_sheet_id = m.group().substring(15, m.group().length() - 1);
			Oauth2Servlet ob2 = new Oauth2Servlet();
			try {
				stm_title = ob2.getSheetTitle(request.getSession().getAttribute("user_id").toString(),
						(String) request.getSession().getAttribute("token"), stm_sheet_id);
				outRes.println(stm_title);
			} catch (Exception ex) {
				outRes.println("Error in fetching title. " + ex.toString());
			}
		} else {
			outRes.print("Cannot parse url. Please enter a valid Google Spreadsheet link");
		}
	}

	if (request.getParameter("spreadsheet_id") != null && !request.getParameter("spreadsheet_id").equals("")
			&& request.getParameter("ws") != null) {
		Pattern p = Pattern.compile("spreadsheets/d/.*/");
		Matcher m = p.matcher(request.getParameter("spreadsheet_id"));
		String stm_sheet_id;
		String stm_title;
		if (m.find()) {
			stm_sheet_id = m.group().substring(15, m.group().length() - 1);
			//Oauth2Servlet ob2 = new Oauth2Servlet();
			SheetsAPI ob = new SheetsAPI();
			try {
				List<String> ws = new ArrayList<String>(
						ob.getWorksheets(request.getSession().getAttribute("user_id").toString(),
								(String) request.getSession().getAttribute("token"), stm_sheet_id));
				//outRes.println("Select worksheets to import: <br>");
				for (String s : ws) {
					outRes.println("<input type='checkbox' name='ws' value='" + s + "'> " + s);
					//	int[] last_row_col = ob.getLastRowCol((String) request.getSession().getAttribute("token"),
					//			stm_sheet_id, s);
					//	outRes.println("/ Last row: " + last_row_col[0] + "," + last_row_col[1]);
					String last_col = ob.getLastCol((String) request.getSession().getAttribute("token"),
							stm_sheet_id, s);
					outRes.println("/ Last col: " + last_col);
				}
			} catch (Exception ex) {
				outRes.println("Error in fetching worksheets. " + ex.toString());

			}

		} else {
			outRes.print("Cannot parse url. Please enter a valid Google Spreadsheet link");
		}
	}

	//function: get testsheets for p_id
	if (request.getParameter("p_id") != null && !request.getParameter("p_id").equals("")
			&& request.getParameter("testsheets") != null) {
		int p_id = Integer.parseInt(request.getParameter("p_id"));
		MySQL_dao ob = new MySQL_dao();
		outRes.println("<option selected disabled>Test Sheet</option>");
		try {
			List<String[]> ts = new ArrayList<String[]>(ob.getTestsheets(p_id));
			for (String s[] : ts) {
				outRes.println("<option value='" + s[0] + "'> " + s[1] + "</option");
			}
		} catch (Exception ex) {
			outRes.println(ex.toString());

		}
	}
	//function: get worksheets for s_id
	if (request.getParameter("s_id") != null && !request.getParameter("s_id").equals("")
			&& request.getParameter("worksheets") != null) {
		String s_id = request.getParameter("s_id");
		SheetsAPI ob = new SheetsAPI();
		outRes.println("<option selected disabled>Worksheet Name</option>");
		try {
			List<String> ws = new ArrayList<String>(
					ob.getWorksheets((String) request.getSession().getAttribute("user_id"),
							(String) request.getSession().getAttribute("token"), s_id));
			for (String s : ws) {
				outRes.println("<option value='" + s + "'> " + s + "</option>");
			}
		} catch (Exception ex) {
			outRes.println(ex.toString());

		}
	}

	if (request.getParameter("query") != null && request.getParameter("result") != null) {
		List<List<Object>> push_rows = new ArrayList<List<Object>>();
		List<Object> push_row = new ArrayList<Object>();
		push_row.add(request.getParameter("query"));
		push_row.add("");
		push_row.add("");
		push_row.add(request.getParameter("result").trim());
		push_rows.add(push_row);

		SheetsAPI ob = new SheetsAPI();
		int last_row = ob.getLastRow((String) request.getSession().getAttribute("token"),
				"16Fy4uF1MVpAkoW-ads6XabQnuOK2HJQ63mn7FUnNjkE", "Second");
		ob.writeSheetData(push_rows, (String) request.getSession().getAttribute("token"),
				"16Fy4uF1MVpAkoW-ads6XabQnuOK2HJQ63mn7FUnNjkE", "ROWS", "Second!F" + last_row);
		outRes.println("Success");

	}

	if (request.getParameter("setProj") != null && request.getParameter("proj_id") != null) {
		request.getSession().setAttribute("proj_id", request.getParameter("proj_id"));
		request.getSession().setAttribute("proj_nm", request.getParameter("proj_nm"));
	}
	if (request.getParameter("tbl_nms") != null && request.getParameter("db_nm") != null
			&& request.getParameter("db_nm") != "") {
		int proj_id = Integer.parseInt(request.getSession().getAttribute("proj_id").toString());
		MySQL_dao ob = new MySQL_dao();
		String[] tbls = ob.getDbTblNames(proj_id, request.getParameter("db_nm"));
		outRes.println("<option selected disabled value=''>Table</option>");
		for (String tbl : tbls)
			outRes.println("<option value='" + tbl + "'>" + tbl + "</option>");
	}

	if (request.getParameter("col_nms") != null && request.getParameter("tbl_nm") != null
			&& request.getParameter("db_nm") != null) {
		MySQL_dao ob = new MySQL_dao();
		List<String[]> cols = ob.getTbl_Columns(request.getParameter("db_nm"), request.getParameter("tbl_nm"));
		outRes.println("Columns: <br> ");
		for (String[] col : cols)
			outRes.println("<input type='checkbox' name='cols' value=" + col[0] + ">" + col[0] + "<br>");
	}

	if (request.getParameter("tasks") != null) {
		MySQL_dao ob = new MySQL_dao();
		List<String[]> tasks = new ArrayList<String[]>(ob.getTasks());
		StringBuilder t = new StringBuilder("");
		for (String[] task : tasks) {
			if("100".equals(task[1]))
				t.append("<h4>" + task[0]
						+ ": Rerun Sheet Task</h4><div class='progress'><div class='progress-bar progress-bar-success' role='progressbar' aria-valuenow='100'aria-valuemin='0' aria-valuemax='100' style='width:100%'>Complete</div></div>");	
			else	
			t.append("<h4>" + task[0]
					+ ": Rerun Sheet Task</h4><div class='progress'><div class='progress-bar progress-bar-striped active' role='progressbar' aria-valuenow='"
					+ task[1] + "'aria-valuemin='0' aria-valuemax='100' style='width: " + task[1] + "%'>"
					+ task[1] + "%</div></div>");
		}
		outRes.println(t);
	}
%>