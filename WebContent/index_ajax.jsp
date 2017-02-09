<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.regex.Matcher"%>
<%
	PrintWriter outRes = response.getWriter();
	if (request.getParameter("check").equals("db")) {

		String inpQuery = request.getParameter("inpQuery");
		String projId = request.getParameter("projId");
		String makeInpQuery = inpQuery;
		String[] inpQueryArray = inpQuery.split(" ");
		int numbOccur = 0;

		String DB_URL = "jdbc:mysql://localhost:3306/parakhi";
		String USER = "root";
		String PASS = "cloudera";
		Connection conn = null;
		Class.forName("com.mysql.jdbc.Driver");

		conn = DriverManager.getConnection(DB_URL, USER, PASS);
		String sql;
		if (projId == "0") {
			sql = "select distinct database_nm from myprojects";
		} else {
			sql = "select distinct database_nm from myprojects where project_id=" + projId;
		}
		PreparedStatement preparedStatement = conn.prepareStatement(sql);
		ResultSet rs = preparedStatement.executeQuery();

		ArrayList<String> db_nms = new ArrayList();
		while (rs.next()) {
			db_nms.add(rs.getString(1));
		}
		preparedStatement.close();
		String output = "";

		String patternTable = "\\$db.\\$table[A-Z]";
		String patternCols = "\\$table[A-Z].\\$col";
		for (int i = 0; i < inpQueryArray.length; i++) {
			if (inpQueryArray[i].equals("$db.$table") || inpQueryArray[i].matches(patternTable)) {
				output = "<ul class='nav' style='display: inline-block'><li class='dropdown'><a data-toggle='dropdown' data-hover='dropdown' data-delay='0' data-close-others='false' class='dropdown-toggle' id='"
						+ inpQueryArray[i] + "' href='#'>" + inpQueryArray[i]
						+ "<b class='caret'></b></a><ul class='dropdown-menu'>";
				String dbQuery = "";

				for (String db_nm : db_nms) {
					if (projId == "0") {
						dbQuery = "select distinct tbl_nm from mytables where db_nm='" + db_nm + "'";
					} else {
						dbQuery = "select distinct tbl_nm from mytables where db_nm='" + db_nm
								+ "' AND project_id=" + projId;
					}
					output = output + "<li><a href='#'>" + db_nm
							+ "<i class='icon-arrow-right'></i></a><ul class='dropdown-menu sub-menu'>";
					PreparedStatement stmt = conn.prepareStatement(dbQuery);
					ResultSet rs_tbl = stmt.executeQuery();
					while (rs_tbl.next()) {
						output = output + "<li><a href='#' onclick=setQueryTblVal('" + db_nm + "','"
								+ rs_tbl.getString(1) + "','" + inpQueryArray[i] + "','"
								+ inpQueryArray[i].substring(inpQueryArray[i].indexOf('.') + 1) + "','" + projId
								+ "')>" + rs_tbl.getString(1) + "</a></li>";
					}
					output = output + "</ul></li>";
				}

				output = output + "</ul></li></ul>";
				//conn.close();
				makeInpQuery = makeInpQuery.replace(inpQueryArray[i], output);
			} else if (inpQueryArray[i].matches(patternCols + "[0-9]")
					|| inpQueryArray[i].matches(patternCols + "s")) {
				makeInpQuery = makeInpQuery.replace(inpQueryArray[i],
						"<span id='" + inpQueryArray[i] + "'>" + inpQueryArray[i] + "</span>");
			}
		}
		conn.close();
		outRes.println(makeInpQuery);
	} else if (request.getParameter("check").equals("col")) {
		String db_nm = request.getParameter("db_nm");
		String tbl_nm = request.getParameter("tbl_nm");
		String col_id = request.getParameter("col_id");
		String proj_id = request.getParameter("proj_id");

		String DB_URL = "jdbc:mysql://localhost:3306/parakhi";
		String USER = "root";
		String PASS = "cloudera";
		Connection conn = null;
		Class.forName("com.mysql.jdbc.Driver");

		conn = DriverManager.getConnection(DB_URL, USER, PASS);
		String colQuery = "select distinct col_nm from mytables where db_nm='" + db_nm + "' AND tbl_nm='"
				+ tbl_nm + "' AND project_id=" + proj_id + "";
		PreparedStatement stmt = conn.prepareStatement(colQuery);
		ResultSet rs_col = stmt.executeQuery();
		String col_nms = "";
		while (rs_col.next()) {
			col_nms = col_nms + rs_col.getString(1) + ",";
		}
		outRes.println(col_nms);
	}
%>