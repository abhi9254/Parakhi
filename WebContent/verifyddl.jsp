<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.google.api.client.auth.oauth2.Credential"%>
<%@page
	import="java.util.List,java.util.ArrayList,java.util.Map,java.util.HashMap"%>
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
<link rel="stylesheet" href="css/chosen.css" type="text/css">
<link href="template_files/style.css" rel="stylesheet" />
<link rel="stylesheet" href="css/style.css" type="text/css">
<link id="t-colors" href="template_files/default.css" rel="stylesheet" />

</head>
<body>


	<div id="wrapper">
		<!-- start header -->
		<header>
		<div class="navbar navbar-inverse navbar-static-top">
			<label style="color: white">Project: <%=request.getSession().getAttribute("proj_nm")%>,
			</label>
			<%
				Credential credential = (Credential) request.getSession()
						.getAttribute("credential");

				Long active_time = null;
				if (credential != null)
					active_time = credential.getExpiresInSeconds();
				if (active_time != null && active_time > 0) {
			%>

			<label style="color: white">User: <%=request.getSession().getAttribute("user_id")%>,
				Token: Active <%=(active_time) / 60%> min
			</label>
			<%
				} else {
			%>
			<label style="color: white">User: <%=request.getSession().getAttribute("user_id")%>,
				Token: Inactive
			</label>
			<%
				}
			%>

			<div class="container" style="float: right; color: white">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse"
						data-target=".navbar-collapse">
						<span class="icon-bar"></span> <span class="icon-bar"></span> <span
							class="icon-bar"></span>
					</button>
				</div>
				<div class="navbar-collapse collapse">
					<ul class="nav navbar-nav">
						<li class="dropdown"><a href="index.jsp" style="color: white">Home</a></li>
						<li class="dropdown"><a href="#" class="dropdown-toggle "
							data-toggle="dropdown" data-hover="dropdown" data-delay="0"
							data-close-others="false" style="color: white">Project <span
								class="glyphicon glyphicon-chevron-down"></span></a>
							<ul class="dropdown-menu">
								<li><a href="#" data-toggle="modal"
									data-target="#styledProject">Styled Project</a></li>
								<li><a href="#" data-toggle="modal"
									data-target="#onSwitchModal">Switch Project</a></li>
								<li><a href="#" data-toggle="modal" data-target="#myModal">New
										Project</a></li>
								<li><a href="project.jsp">View Project</a></li>
							</ul></li>
						<li class="dropdown"><a href="#" class="dropdown-toggle"
							data-toggle="dropdown" data-hover="dropdown" data-delay="0"
							data-close-others="false" style="color: white">Sheets <span
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
								<li><a href="">Verify DDLs</a></li>
							</ul></li>
						<li class="dropdown"><a href="datafit.jsp"
							style="color: white">Data Fit</a></li>
						<li class="dropdown"><a href="cross_section.jsp"
							style="color: white">Cross Section</a></li>
						<li class="dropdown"><a href="history.jsp"
							style="color: white">History</a></li>
						<li class="dropdown"><a href="settings.jsp"
							style="color: white">Settings</a></li>

						<%
							if (request.getSession().getAttribute("user_id") == null) {
						%>
						<li class=""><a href="login.jsp" style="color: white">Login</a></li>
						<%
							} else {
						%>
						<li class=""><a href="login.jsp" style="color: white">Logout</a></li>
						<%
							}
						%>
					</ul>
				</div>
			</div>
		</div>
		</header>
		<!-- end header -->

	</div>

	<div style="margin: 20px">
		<%
			String stm_table = request.getParameter("stm_tbl");
			String hive_table = request.getParameter("hive_tbl");
			boolean match = true;

			List<String[]> stmColumns = new ArrayList<String[]>();
			List<String[]> hiveColumns = new ArrayList<String[]>();

			MySQL_dao ob = new MySQL_dao();
			List<String[]> stmCols = new ArrayList<String[]>(ob.getStmTgtCols(
					"1o38ctGSfl3tm2_MnIbK4GxhDpJRl5lsFz4TkcfWFu8A"));
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
				Connection con = DriverManager.getConnection(
						"jdbc:hive2://localhost:10000/default", "hive", "");
				Statement stmt = (Statement) con.createStatement();

				String query = "describe " + "db_gold.gold_product_sku";
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
						"<h4 style='color:green ;display:inline'>Pass</h4><br><br>");
			else
				out.println(
						"<h4 style='color:red;display:inline'>Fail</h4><br><br>");
		%>



		<table class="table" style="width: 800px">

			<thead>
				<tr>
					<th>Hive Column</th>
					<th>Hive Datatype</th>
					<th>STM Column</th>
					<th>STM Datatype</th>
				</tr>
			</thead>
			<tbody>

				<%
					int total_dis_Cols = 0;
					List<String> disColumns = new ArrayList<String>();

					//  get count of total distinct cols

					for (int i = 0; i < hiveColumns.size(); i++) {
						disColumns.add(
								hiveColumns.get(i)[1].concat(hiveColumns.get(i)[2]));
						total_dis_Cols++;
					}
					for (int i = 0; i < stmColumns.size(); i++) {
						if (!disColumns.contains(
								stmColumns.get(i)[1].concat(stmColumns.get(i)[2])))
							total_dis_Cols++;
					}

					int breaker = 0;
					int counter = 0;

					List<String[]> allColumns = new ArrayList<String[]>();

					//  maps for check contains function and coloring
					//	Map<String,String> stmMap = new HashMap<String,String>();
					//	Map<String,String> hiveMap = new HashMap<String,String>();

					for (int i = 0; i < total_dis_Cols
							&& counter < total_dis_Cols; i++) {
						boolean flag = false;
						int j = breaker;
						try {
							if (hiveColumns.get(i)[1].equals(stmColumns.get(j)[1])
									&& hiveColumns.get(i)[2]
											.equals(stmColumns.get(j)[2])) {
								String[] total = new String[4];
								total[0] = hiveColumns.get(i)[1];
								total[1] = hiveColumns.get(i)[2];
								total[2] = stmColumns.get(j)[1];
								total[3] = stmColumns.get(j)[2];
				%>
				<tr>
					<td><%=total[0]%></td>
					<td><%=total[1]%></td>
					<td><%=total[2]%></td>
					<td><%=total[3]%></td>
				</tr>
				<%
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
										String[] total = new String[4];
										total[0] = "--";
										total[1] = "--";
										total[2] = stmColumns.get(breaker)[1];
										total[3] = stmColumns.get(breaker)[2];
				%>
				<tr>
					<td><%=total[0]%></td>
					<td><%=total[1]%></td>
					<td><%=total[2]%></td>
					<td><%=total[3]%></td>
				</tr>
				<%
					breaker++;
										i--;
										counter++;
										break;
									}
								}

								if (!flag) {
									String[] total = new String[4];
									total[0] = hiveColumns.get(i)[1];
									total[1] = hiveColumns.get(i)[2];
									total[2] = "--";
									total[3] = "--";
				%>
				<tr>
					<td><%=total[0]%></td>
					<td><%=total[1]%></td>
					<td><%=total[2]%></td>
					<td><%=total[3]%></td>
				</tr>
				<%
					counter++;
								}

							}
						} catch (IndexOutOfBoundsException ex) {
							if (breaker < stmColumns.size()) {
								String[] total = new String[4];
								total[0] = "--";
								total[1] = "--";
								total[2] = stmColumns.get(breaker)[1];
								total[3] = stmColumns.get(breaker)[2];
				%>
				<tr>
					<td><%=total[0]%></td>
					<td><%=total[1]%></td>
					<td><%=total[2]%></td>
					<td><%=total[3]%></td>
				</tr>
				<%
					} else {
								String[] total = new String[4];
								total[0] = hiveColumns.get(i)[1];
								total[1] = hiveColumns.get(i)[2];
								total[2] = "--";
								total[3] = "--";
				%>
				<tr>
					<td><%=total[0]%></td>
					<td><%=total[1]%></td>
					<td><%=total[2]%></td>
					<td><%=total[3]%></td>
				</tr>
				<%
					}

							breaker++;
							counter++;
						}

					}
				%>
			</tbody>
		</table>
	</div>
</body>
</html>