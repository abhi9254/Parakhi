<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.regex.Matcher"%>
<%@ page import="org.abhi.parakhi.MySQL_dao"%>
<%
	PrintWriter outRes = response.getWriter();
	if (request.getParameter("projId") != null && request.getParameter("inpQuery") != null) {

		String inpQuery = request.getParameter("inpQuery");
		int projId = Integer.parseInt(request.getParameter("projId"));

		MySQL_dao ob = new MySQL_dao();
		List<String> dbs = new ArrayList<String>(ob.getProjDbNames(projId));

		StringBuilder s = new StringBuilder("");
		s.append("<select id='tables' class='chosen-select'  tabindex='4'>");
		s.append("<option value='' selected disabled>Select table</option>");
		for (String db : dbs) {
			s.append("<optgroup label='" + db + "'>");

			String[] tbls = ob.getDbTblNames(projId, db);
			for (String tbl : tbls)
				s.append("<option value='" + db + "." + tbl + "'>" + tbl + "</option>");
		}
		s.append("</optgroup></select>");

		String db_text = "$db.$tableA";
		String rep = inpQuery.replace("$db.$tableA", s);
		outRes.println(rep);
	}

	if (request.getParameter("col_nms") != null && request.getParameter("selected") != null) {
		String db_nm_tbl_nm = request.getParameter("selected");

		MySQL_dao ob = new MySQL_dao();
		int proj_id = 0;
		if (request.getSession().getAttribute("proj_id") != null) {
			proj_id = Integer.parseInt(request.getSession().getAttribute("proj_id").toString());
		}

		List<String> cols = new ArrayList<String>(ob.getTbl_Columns(proj_id, db_nm_tbl_nm));

		StringBuilder s = new StringBuilder("");
		StringBuilder all = new StringBuilder("");
		s.append(
				"<select id='columns' name='columns' class='chosen-select column'  data-placeholder='Select columns' style='min-width:180px' multiple tabindex='4'>");
		//	s.append("<option value='' selected disabled>Select columns</option>");
		if (cols.size() != 0) {

			s.append("<option value='*'>*</option>");

			int i = 1;
			for (String col : cols) {
				s.append("<option value='" + col + "'>" + col + "</option>");

				if (i == 1)
					all.append(col);
				else
					all.append("," + col);

				i++;
			}
			s.append("<option value=" + all + ">All</option>");
		} else {
			s.append("<option value='' disabled>No columns</option>");
		}

		s.append("</select>");

		outRes.println(s);
	}
%>


