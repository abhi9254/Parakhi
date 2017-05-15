<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.google.api.client.auth.oauth2.Credential"%>
<%@page
	import="java.util.List,java.util.ArrayList,java.util.Set,java.util.HashSet"%>
<%@ page import="org.abhi.parakhi.MySQL_dao"%>
<%@page
	import="java.sql.DriverManager, java.sql.Connection, java.sql.ResultSet, java.sql.Statement"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
<head>
<meta charset="utf-8">
<title>Parakhi - 0.7</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta name="description" content="Parakhi" />

<link rel="stylesheet" href="css/bootstrap.min.css" type="text/css">
<link rel="stylesheet" href="css/jquery.dataTables.min.css"
	type="text/css">
<link href="template_files/style.css" rel="stylesheet" />
<link rel="stylesheet" href="css/style.css" type="text/css" />

<style>
#comparetbl_wrapper {
	width: 100%
}
</style>

<script src="js/jquery-3.1.1.min.js" type="text/javascript"></script>
<script src="js/bootstrap.min.js" type="text/javascript"></script>
<script src="js/jquery.dataTables.min.js" type="text/javascript"></script>
<script>
	$(document).ready(function() {
		$('#comparetbl').DataTable({
			order : [],
			paging : false,
			info : false
		});
	});
</script>
</head>
<body>

	<header>
	<div class="navbar navbar-inverse navbar-static-top">
		<small style="color: white">Project: <%=request.getSession().getAttribute("proj_nm")%>,
		</small>
		<%
			Credential credential = (Credential) request.getSession()
					.getAttribute("credential");

			Long active_time = null;
			if (credential != null)
				active_time = credential.getExpiresInSeconds();
			if (active_time != null && active_time > 0) {
		%>

		<small style="color: white"> Token: Active <%=(active_time) / 60%>
			min
		</small>

		<%
			} else {
		%>
		<small style="color: white"> Token: Inactive </small>
		<%
			}
		%>

		<div class="container" style="float: right">
			<ul class="nav navbar-nav" style="float: right; color: white">
				<li class="dropdown"><a href="index.jsp" style="color: white"><span
						class="glyphicon glyphicon-home"></span>&nbsp;Home </a></li>
				<li class="dropdown"><a href="#" class="dropdown-toggle "
					data-toggle="dropdown" data-hover="dropdown" data-delay="0"
					data-close-others="false" style="color: white"><span
						class="glyphicon glyphicon-folder-open"></span>&nbsp;&nbsp;Project
						<span class="glyphicon glyphicon-chevron-down"></span></a>
					<ul class="dropdown-menu">
						<li><a href="#" data-toggle="modal"
							data-target="#styledProject">Switch Project</a></li>
						<li><a href="#" data-toggle="modal"
							data-target="#styledProject">New Project</a></li>
						<li><a href="project.jsp">View Project</a></li>
					</ul></li>
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" data-hover="dropdown" data-delay="0"
					data-close-others="false" style="color: white"><span
						class="glyphicon glyphicon-book"></span>&nbsp;Sheets <span
						class="glyphicon glyphicon-chevron-down"></span></a>
					<ul class="dropdown-menu">
						<li><a target="_blank"
							href="https://docs.google.com/spreadsheets/d/16Fy4uF1MVpAkoW-ads6XabQnuOK2HJQ63mn7FUnNjkE">View
								Test Sheet</a></li>
						<li><a target="_blank"
							href="https://docs.google.com/spreadsheets/d/1o38ctGSfl3tm2_MnIbK4GxhDpJRl5lsFz4TkcfWFu8A/edit">View
								STM</a></li>
						<li><a href="" data-toggle="modal" data-target="#myModal2">Rerun
								Sheet</a></li>
						<li><a href="" data-toggle="modal" data-target="#verifyddl">Verify
								DDLs</a></li>
					</ul></li>

				<li class="dropdown"><a href="cross_section.jsp"
					style="color: white"><span class="glyphicon glyphicon-record"></span>&nbsp;Cross
						Section</a></li>
				<li class="dropdown"><a href="history.jsp" style="color: white"><span
						class="glyphicon glyphicon-time"></span>&nbsp;History</a></li>
				<li class="dropdown"><a href="settings.jsp"
					style="color: white"><span class="glyphicon glyphicon-cog"></span>&nbsp;Settings</a></li>

				<%
					if (request.getSession().getAttribute("user_id") == null) {
				%>
				<li class=""><a href="login.jsp" style="color: white"><span
						class="glyphicon glyphicon-user"></span>&nbsp;Login</a></li>
				<%
					} else {
				%>
				<li class=""><a href="login.jsp" style="color: white"><span
						class="glyphicon glyphicon-user"></span>&nbsp;Logout</a></li>
				<%
					}
				%>
			</ul>
		</div>
	</div>
	</header>


	<div style="margin: 20px">
		<%
			String hive_table = request.getParameter("hive_tbl");
			out.println("<label>Hive: " + hive_table + "</label><br>");

			String stm_table = request.getParameter("stm_tbl");
			out.println("<label>Stm: " + stm_table + "</label><br><br>");

			boolean match = true;

			List<String[]> stmColumns = new ArrayList<String[]>();
			List<String[]> hiveColumns = new ArrayList<String[]>();

			MySQL_dao ob = new MySQL_dao();
			List<String[]> stmCols = new ArrayList<String[]>(
					ob.getStmTgtCols(stm_table));
			for (String[] stmCol : stmCols) {
				stmColumns.add(stmCol);
			}

			String driverName = "org.apache.hive.jdbc.HiveDriver";

			try {
				Class.forName(driverName);
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
			try {
				Connection con = DriverManager.getConnection("jdbc:hive2://10.200.99.242:10000/default", "hive", "");
			// Connection con = DriverManager.getConnection("jdbc:hive2://localhost:10000/default", "hive", "");
					
			Statement stmt = (Statement) con.createStatement();

				String query = "describe " + hive_table;
				//"db_insight.insight_monetization_all_transaction";
				ResultSet hiveCols = stmt.executeQuery(query);
				while (hiveCols.next()) {
					if (hiveCols.getString(1).charAt(0) == '#'
							|| hiveCols.getString(1) == "")
						break;
					String[] s = new String[3];
					s[0] = String.valueOf(hiveCols.getRow());
					s[1] = hiveCols.getString(1);
					s[2] = hiveCols.getString(2);
					hiveColumns.add(s);

				}
				hiveCols.close();
				con.close();
			} catch (Exception ex) {
				ex.printStackTrace();
			}

			int totalCols = hiveColumns.size();
			if (totalCols == stmColumns.size()) {
				for (int i = 0; i < totalCols; i++) {

					if (!(hiveColumns.get(i)[1].equals(stmColumns.get(i)[1])
							&& hiveColumns.get(i)[2]
									.equals(stmColumns.get(i)[2])))
						match = false;
				}
			} else
				match = false;

			out.print("<h4 style='display:inline'>Verification: </h4>");
			if (match)
				out.println(
						"<h4 style='color:green ;display:inline'>Pass</h4>");
			else
				out.println("<h4 style='color:red;display:inline'>Fail</h4>");
		%>



		<table id="comparetbl" class="table" style="width: 100%">

			<thead>
				<tr>
					<th>Hive S.no</th>
					<th>Hive Column</th>
					<th>Hive Datatype</th>
					<th>STM S.no</th>
					<th>STM Column</th>
					<th>STM Datatype</th>
					<th>Remarks</th>
				</tr>
			</thead>
			<tbody>

				<%
					int total_dis_Cols = 0;
					int total_cols = hiveColumns.size() + stmColumns.size();

					//  sets for check contains function
					Set<String> stmSet = new HashSet<String>();
					Set<String> hiveSet = new HashSet<String>();

					List<String> disColumns = new ArrayList<String>();

					//  get count of total distinct cols and total cols

					for (int i = 0; i < hiveColumns.size(); i++) {
						hiveSet.add(
								hiveColumns.get(i)[1].concat(hiveColumns.get(i)[2]));

						disColumns.add(
								hiveColumns.get(i)[1].concat(hiveColumns.get(i)[2]));
						total_dis_Cols++;
					}
					for (int i = 0; i < stmColumns.size(); i++) {
						stmSet.add(stmColumns.get(i)[1].concat(stmColumns.get(i)[2]));

						if (!disColumns.contains(
								stmColumns.get(i)[1].concat(stmColumns.get(i)[2])))
							total_dis_Cols++;
					}

					int breaker = 0;
					int counter = 0;

					//List<String[]> allColumns = new ArrayList<String[]>();

					for (int i = 0; i < total_cols && counter < total_cols; i++) {
						boolean flag = false;
						boolean printed = false;
						int j = breaker;
						try {
							if (hiveColumns.get(i)[1].equals(stmColumns.get(j)[1])
									&& hiveColumns.get(i)[2]
											.equals(stmColumns.get(j)[2])) {
								String[] total = new String[7];

								total[0] = hiveColumns.get(i)[0];
								total[1] = hiveColumns.get(i)[1];
								total[2] = hiveColumns.get(i)[2];
								total[3] = stmColumns.get(j)[0];
								total[4] = stmColumns.get(j)[1];
								total[5] = stmColumns.get(j)[2];
								total[6] = "";
				%>
				<tr>
					<td><%=total[0]%></td>
					<td><%=total[1]%></td>
					<td><%=total[2]%></td>
					<td><%=total[3]%></td>
					<td><%=total[4]%></td>
					<td><%=total[5]%></td>
					<td><%=total[6]%></td>
				</tr>
				<%
					printed = true;
								breaker++;
								counter++;
							}

							else {

								for (int k = j; k < stmColumns.size()
										&& breaker < stmColumns.size(); k++) {
									if (hiveColumns.get(i)[1]
											.equals(stmColumns.get(k)[1])
											&& hiveColumns.get(i)[2]
													.equals(stmColumns.get(k)[2])) {
										flag = true;
										String[] total = new String[7];
										total[0] = "";
										total[1] = "";
										total[2] = "";
										total[3] = stmColumns.get(breaker)[0];
										total[4] = stmColumns.get(breaker)[1];
										total[5] = stmColumns.get(breaker)[2];
										if (hiveSet.contains(stmColumns.get(breaker)[1]
												.concat(stmColumns.get(breaker)[2])))
											total[6] = "Order issue";
										else
											total[6] = "Not in Hive";
				%>
				<tr>
					<td><%=total[0]%></td>
					<td><%=total[1]%></td>
					<td><%=total[2]%></td>
					<td><%=total[3]%></td>
					<td><%=total[4]%></td>
					<td><%=total[5]%></td>
					<td><%=total[6]%></td>
				</tr>
				<%
					printed = true;
										breaker++;
										i--;
										counter++;
										break;
									}
								}

								if (!flag) {
									String[] total = new String[7];
									total[0] = hiveColumns.get(i)[0];
									total[1] = hiveColumns.get(i)[1];
									total[2] = hiveColumns.get(i)[2];
									total[3] = "";
									total[4] = "";
									total[5] = "";
									if (stmSet.contains(hiveColumns.get(i)[1]
											.concat(hiveColumns.get(i)[2])))
										total[6] = "Order issue";
									else
										total[6] = "Not in Stm";
				%>
				<tr>
					<td><%=total[0]%></td>
					<td><%=total[1]%></td>
					<td><%=total[2]%></td>
					<td><%=total[3]%></td>
					<td><%=total[4]%></td>
					<td><%=total[5]%></td>
					<td><%=total[6]%></td>
				</tr>
				<%
					printed = true;
									counter++;
								}

							}
						} catch (IndexOutOfBoundsException ex) {
							if (breaker < stmColumns.size()) {
								String[] total = new String[7];
								total[0] = "";
								total[1] = "";
								total[2] = "";
								total[3] = stmColumns.get(breaker)[0];
								total[4] = stmColumns.get(breaker)[1];
								total[5] = stmColumns.get(breaker)[2];
								total[6] = "Not in Hive *";
				%>
				<tr>
					<td><%=total[0]%></td>
					<td><%=total[1]%></td>
					<td><%=total[2]%></td>
					<td><%=total[3]%></td>
					<td><%=total[4]%></td>
					<td><%=total[5]%></td>
					<td><%=total[6]%></td>
				</tr>
				<%
					printed = true;

								breaker++;
								counter++;
							} else if (i < hiveColumns.size()) {
								String[] total = new String[7];
								total[0] = hiveColumns.get(i)[0];
								total[1] = hiveColumns.get(i)[1];
								total[2] = hiveColumns.get(i)[2];
								total[3] = "";
								total[4] = "";
								total[5] = "";
								total[6] = "Not in Stm *";
				%>
				<tr>
					<td><%=total[0]%></td>
					<td><%=total[1]%></td>
					<td><%=total[2]%></td>
					<td><%=total[3]%></td>
					<td><%=total[4]%></td>
					<td><%=total[5]%></td>
					<td><%=total[6]%></td>
				</tr>
				<%
					printed = true;

								breaker++;
								counter++;
							}
						}
						if (!printed)
							break;
					}
				%>
			</tbody>
		</table>
	</div>
</body>
</html>