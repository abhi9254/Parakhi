
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page
	import="java.io.PrintWriter,java.sql.DriverManager,java.sql.Connection,java.sql.ResultSet,java.sql.ResultSetMetaData,org.apache.hive.jdbc.HiveStatement,java.sql.Statement,java.sql.SQLException"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>Parakhi - 0.7</title>
<link rel="stylesheet" href="/Parakhi/style.css" type="text/css">

<script type="text/javascript" src="/Parakhi/js/google_sheets_api.js"></script>
<script type="text/javascript" src="/Parakhi/js/jquery-3.1.1.min.js"></script>
<script type="text/javascript"
	src="/Parakhi/js/jquery.tablesorter.min.js"></script>
<script src="https://apis.google.com/js/client.js?onload=checkAuth"></script>
<script>
	$(document).ready(function() {
		$("#res_tbl").tablesorter();
	});
</script>

<style>
body {
	font-family: "Lato", sans-serif;
}

ul.tab {
	list-style-type: none;
	margin: 0;
	padding: 0;
	overflow: hidden;
	border: 1px solid #ccc;
	background-color: #f1f1f1;
}

/* Float the list items side by side */
ul.tab li {
	float: left;
}

/* Style the links inside the list items */
ul.tab li a {
	display: inline-block;
	color: black;
	text-align: center;
	padding: 14px 16px;
	text-decoration: none;
	transition: 0.3s;
	font-size: 17px;
}

/* Change background color of links on hover */
ul.tab li a:hover {
	background-color: #ddd;
}

/* Create an active/current tablink class */
ul.tab li a:focus, .active {
	background-color: #ccc;
}

/* Style the tab content */
.tabcontent {
	display: none;
	padding: 6px 12px;
	border: 1px solid #ccc;
	border-top: none;
}
</style>

</head>
<body>

	<ul class="hor_nav_bar">
		<li class="hor_li"><a class="hor_li inactive" href="index.jsp">Home</a></li>
		<li class="hor_li"><a class="hor_li inactive" href="history.jsp">History</a></li>
		<li class="hor_li"><a class="hor_li inactive" href=""
			data-toggle="modal" data-target="#myModal">Project</a></li>
		<li class="hor_li"><a class="hor_li inactive" target="_blank"
			href="https://docs.google.com/spreadsheets/d/16Fy4uF1MVpAkoW-ads6XabQnuOK2HJQ63mn7FUnNjkE">Sheets</a></li>
		<li class="hor_li"><a class="hor_li inactive" href=""
			data-toggle="modal" data-target="#myModal2">Rerun Sheet</a></li>
		<li class="hor_li"><a class="hor_li inactive" href="cross_section.jsp">Cross Section</a></li>
		<li class="hor_li" style="float: right"><a
			class="hor_li inactive" href="settings.jsp">Settings</a></li>
		<li class="hor_li" style="float: right"><a
			class="hor_li inactive" href="">Login</a></li>
	</ul>

	<form action="SheetsAPI" method="post">
		<br> <input type="button" name="back" class="back-button"
			value="< Back" onclick="history.back()"> <input type="submit"
			class="push-button" value="Push Result"><br> <br>
		<ul class="tab">
			<li><a href="javascript:void(0)" class="tablinks"
				onclick="openTab(event, 'Query')" id="defaultOpen">Query</a></li>
			<li><a href="javascript:void(0)" class="tablinks"
				onclick="openTab(event, 'Result')">Result</a></li>
			<li><a href="javascript:void(0)" class="tablinks"
				onclick="openTab(event, 'Log')">Log</a></li>
		</ul>

		<div id="Query" class="tabcontent">
			<%
				String query = request.getAttribute("user_query").toString();
			%>
			<pre id="query"><%=query%></pre>
		</div>

		<div id="Result" class="tabcontent" style="overflow-x: auto">
			<table id="res_tbl" class="tablesorter" cellspacing="1">
				<%
				String driverName = "org.apache.hive.jdbc.HiveDriver";

				try {
					Class.forName(driverName);
				} catch (ClassNotFoundException e) {
					e.printStackTrace();
				}
				Connection con = DriverManager.getConnection("jdbc:hive2://localhost:10000/default", "hive", "");
				HiveStatement stmt = (HiveStatement) con.createStatement();
					ResultSet res = (ResultSet) request.getAttribute("result");
					ResultSetMetaData rsmd = res.getMetaData();
					PrintWriter writer = response.getWriter();
					int columnsNumber = rsmd.getColumnCount();
					
					// Print Column names
					int dot_pos = rsmd.getColumnName(1).indexOf(".") + 1;
				%>
				<thead>
					<tr>
						<th class="header"></th>
						<%
							for (int i = 1; i <= columnsNumber; i++) {
						%><th class="header"><%=rsmd.getColumnName(i).substring(dot_pos)%></th>
						<%
							}
						%>
					</tr>
				</thead>


				<tbody>
					<%
						while (res.next()) {
					%><tr>
						<td style="padding: 6px"><%=res.getRow()%></td>
						<%
							for (int c = 1; c <= columnsNumber; c++) {
						%>
						<td><%=res.getString(c)%></td>

						<%
							}
						%>

					</tr>
					<%
						}
						res.close();
					%>
				</tbody>
			</table>
		</div>

		<div id="Log" class="tabcontent">
			<%
				String logs = stmt.getLog().toString();
				System.out.println(logs);
			%>
			<pre><%=logs%></pre>
		</div>


		<div id="pushText" style="display: none"></div>

	</form>


	<div id="authorize-div" style="display: none">
		<span>Authorize access to Google Sheets API</span>
		<!--Button for the user to click to initiate auth sequence -->
		<button id="authorize-button" onclick="handleAuthClick(event)">
			Authorize</button>
	</div>
	<pre id="output"></pre>



</body>

<script type="text/javascript">
	function openTab(evt, tabName) {
		var i, tabcontent, tablinks;
		tabcontent = document.getElementsByClassName("tabcontent");
		for (i = 0; i < tabcontent.length; i++) {
			tabcontent[i].style.display = "none";
		}
		tablinks = document.getElementsByClassName("tablinks");
		for (i = 0; i < tablinks.length; i++) {
			tablinks[i].className = tablinks[i].className
					.replace(" active", "");
		}
		document.getElementById(tabName).style.display = "block";
		evt.currentTarget.className += " active";
	}

	// Get the element with id="defaultOpen" and click on it
	document.getElementById("defaultOpen").click();

	var query_ = document.getElementById('query').innerHTML;
	var query = query_.replace(/\n/g, "/n");
	var row_c = document.getElementById('res_tbl').rows.length;
	var pos = 'First!D8:E9'

	var i = 0, j = 0;
	var str = " ";

	for (i = 0; i < row_c; i++) {
		str = str + "/n";

		var cell_c = document.getElementById("res_tbl").rows[i].cells.length;

		for (j = 0; j < cell_c; j++) {

			var x = document.getElementById("res_tbl").rows[i].cells.item(j).innerHTML;

			str = str + x + "\t";

		}

	}

	document.getElementById("pushText").innerHTML = '<input type="text" id="p1-query" name="p1-query" value="'+query+'"> <br> <input type="text" id="p2-result" name="p2-result" value="'+str+'">';
</script>

</html>
