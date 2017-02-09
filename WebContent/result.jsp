
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page
	import="java.io.PrintWriter,java.sql.DriverManager,java.sql.Connection,java.sql.ResultSet,java.sql.ResultSetMetaData,java.sql.Statement,java.sql.SQLException"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>Parakhi - 0.7</title>
<link rel="stylesheet" href="/Parakhi/style.css" type="text/css">
<script type="text/javascript" src="/Parakhi/js/google_sheets_api.js"></script>
<script type="text/javascript" src="/Parakhi/js/jquery-3.1.1.min.js"></script>
<script type="text/javascript" src="/Parakhi/js/bootstrap.min.js"></script>
<script type="text/javascript"
	src="/Parakhi/js/jquery.tablesorter.min.js"></script>

<!-- css -->
<link href="template_files/bootstrap.min.css" rel="stylesheet" />
<link href="template_files/style.css" rel="stylesheet" />
<link rel="stylesheet" href="css/style.css" type="text/css">
<link href="template_files/bootstrap_multiselect.min.css"
	rel="stylesheet" type="text/css" />
<script>
	$(document).ready(function() {
		$("#res_tbl").tablesorter();
	});
</script>
<script>
	function traceRows(tbl_nm) {

		var header_row = document.getElementById("row_0").cells;
		var headers = [];
		for (i = 1; i < header_row.length - 1; i++)
			headers.push(header_row[i].innerHTML);

		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax2.jsp?trace_tbl_nm=" + tbl_nm, true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {
				document.getElementById("src_db_nms").innerHTML = x.responseText
						.trim();
			}
		}
	}

	function traceRows2() {

		var tbl_nms_text = document.getElementById("src_db_nms").innerHTML;
		var tbl_nms = tbl_nms_text.split(',');
		var tbl_arr = [];
		var contains = false;
		for (i = 0; i < tbl_nms.length; i++) {
			//alert("in outer loop")
			var str = tbl_nms[i]
			var tbl_nm = str.substring(0, str.indexOf(' '))

			for (j = 0; j < tbl_arr.length; j++) {
				//alert("check exists?")
				if (tbl_arr[j] == tbl_nm) {
					//alert("exists")
					contains = true;
					break;
				}

			}
			if (contains == false) {

				//alert("new push " + tbl_nm)
				tbl_arr.push(tbl_nm)
			}

		}
		//alert(tbl_arr)
		var track_creator = '';
		for (i = 0; i < tbl_arr.length; i++) {
			track_creator += "<form action='Query' method='post' target='_blank' id='"+tbl_arr[i]+"'><label>" + tbl_arr[i]
					+ "</label><br></form><br>";

		}
		document.getElementById("tracker").innerHTML = track_creator;

		for (i = 0; i < tbl_nms.length; i++) {
			//alert("in outer loop")
			var str = tbl_nms[i]
			var tbl_nm = str.substring(0, str.indexOf(' '))
			var col_nm = str.substring(str.indexOf(' ') + 1)

			document.getElementById(tbl_nm).innerHTML += "<input type='checkbox' name='cols"+"' value='"+col_nm+"' checked='true'>"
					+ col_nm;

		}
		for (i = 0; i < tbl_arr.length; i++) {

			document.getElementById(tbl_arr[i]).innerHTML += "<input type='text' style='display:none' name = 'query_text' value='select * from "+tbl_arr[i]+"'/><input type='submit' value='Trace' class='btn btn-info' style='float: right'>"
		}
	}
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
	<!-- start header -->
	<header>
	<div class="navbar navbar-inverse navbar-static-top">
		<div class="container" style="float: right; color: white">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target=".navbar-collapse">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<!-- <a class="navbar-brand" href="index.html"><img
						src="template_files/img/logo.png" alt="" width="199" height="52" /></a> -->
			</div>
			<div class="navbar-collapse collapse">
				<ul class="nav navbar-nav">
					<li class="dropdown"><a href="index.jsp" style="color: white">Home</a></li>
					<li class="dropdown"><a href="#" class="dropdown-toggle "
						data-toggle="dropdown" data-hover="dropdown" data-delay="0"
						data-close-others="false" style="color: white">Project <span
							class="glyphicon glyphicon-chevron-down"></span></a>
						<ul class="dropdown-menu">
							<li><a href="index.jsp">Switch Project</a></li>
							<li><a href="#" data-toggle="modal" data-target="#myModal">New
									Project</a></li>
						</ul></li>
					<li class="dropdown"><a href="#" class="dropdown-toggle"
						data-toggle="dropdown" data-hover="dropdown" data-delay="0"
						data-close-others="false" style="color: white">Sheets <span
							class="glyphicon glyphicon-chevron-down"></span></a>
						<ul class="dropdown-menu">
							<li><a target="_blank"
								href="https://docs.google.com/spreadsheets/d/16Fy4uF1MVpAkoW-ads6XabQnuOK2HJQ63mn7FUnNjkE">View
									Sheet</a></li>
							<li><a href="" data-toggle="modal" data-target="#myModal2">Rerun
									Sheet</a></li>
						</ul></li>
					<li class="dropdown"><a href="cross_section.jsp"
						style="color: white">Cross Section</a></li>
					<li class="dropdown"><a href="history.jsp"
						style="color: white">History</a></li>
					<li class="dropdown"><a href="settings.jsp"
						style="color: white">Settings</a></li>


					<li class=""><a href="" data-toggle="modal"
						data-target="#loginModal" style="color: white">Login</a></li>
				</ul>
			</div>
		</div>
	</div>
	</header>
	<!-- end header -->



	<br>
	<input type="button" name="back" class="back-button" value="< Back"
		onclick="history.back()">
	<!-- Push function defined in google api js -->
	<input type="button" id="push-div" onclick="pushToSheet()"
		class="push-button" style="display: inline" value="Push Result">
	<!-- Do not change this buttons ID -->
	<button id="authorize-div" class="push-button" style="display: none"
		onclick="handleAuthClick(event)">Authorize to push</button>
	<button id="trace-div" class="push-button" style="display: inline"
		href="" data-toggle="modal" data-target="#traceModal">Trace</button>

	<pre id="output" style="display: inline"></pre>
	<br>
	<br>
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
				ResultSet res = (ResultSet) request.getAttribute("result");
				ResultSetMetaData rsmd = res.getMetaData();
				PrintWriter writer = response.getWriter();
				int columnsNumber = rsmd.getColumnCount();

				// Print Column names
				int dot_pos = rsmd.getColumnName(1).indexOf(".") + 1;
			%>
			<thead>
				<tr id="row_0">
					<th class="header"></th>
					<%
						for (int i = 1; i <= columnsNumber; i++) {
					%><th class="header"><%=rsmd.getColumnName(i).substring(dot_pos)%></th>
					<%
						}
					%><th class="header">Trace</th>
				</tr>
			</thead>


			<tbody>
				<%
					while (res.next()) {
				%><tr id="row_<%=res.getRow()%>">
					<td style="padding: 6px"><%=res.getRow()%></td>
					<%
						for (int c = 1; c <= columnsNumber; c++) {
					%>
					<td><%=res.getString(c)%></td>

					<%
						}
					%>
					<td><input type="checkbox" name='trace'
						value="row_<%=res.getRow()%>"> <!-- <button id='bt_btn_<%=res.getRow()%>'>Trace</button>  -->
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
			String logs = request.getAttribute("query_log").toString();
			System.out.println(logs);
		%>
		<pre><%=logs%></pre>
	</div>


	<div id="pushText" style="display: none"></div>

	<div class="modal fade" id="traceModal" role="dialog">
		<div class="modal-dialog modal-lg">

			<!-- Modal content-->
			<div class="panel panel-info">
				<div class="panel panel-heading">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Trace Rows</h4>
				</div>
				<div class="panel panel-body">

					<label id="src_db_nms">src_db_nms</label><br>
					<button onclick="traceRows('db_gold.gold_product_sku')">fetch</button>
					<br>
					<div id="tracker">tracker</div>
					<button onclick="traceRows2()">fetch</button>
					<br>

			<!--  		<form action='trace.jsp' method='post'>
						<label>db_stage.raw_sku</label><br> <input type="checkbox"
							name='cols1' value="sku_id"> sku_id <input
							type="checkbox" name='cols1' value="sku_nm"> sku_nm <input
							type="submit" value="Trace" class="btn btn-info"
							style="float: right"> <br>
					</form>
					<br>
					<form action='trace.jsp' method='post'>
						<label>db_stage.raw_product</label><br> <input
							type="checkbox" name='cols2' value="product_id">
						product_id <input type="checkbox" name='cols2' value="dept_nm">
						dept_nm <input type="checkbox" name='cols2' value="price">
						price <input type="submit" value="Trace" class="btn btn-info"
							style="float: right"> <br>
					</form>
		-->		</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>



	<div class="modal fade" id="myModal" role="dialog">
		<div class="modal-dialog modal-lg">

			<!-- Modal content-->
			<div class="panel panel-primary">
				<div class="panel panel-heading">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title" style="color: white">New Project</h4>
				</div>
				<div class="modal-body">
					<div class="panel panel-primary">
						<div class="panel panel-body">
							<form action='' method='post'>
								<input type="text" name="pname" placeholder="Project name"
									class="form-control" /> <br />
								<textarea name="pdesc" style="resize: none" rows="5"
									placeholder="Project Description" class="form-control"></textarea>
								<br /> Database <select class="form-control">
									<option>db_gold</option>
									<option>db_stage</option>
								</select> <br /> Tables <select class="form-control">
									<option>gold_product_sku</option>
									<option>gold_sales_dly</option>
								</select> <br> <br> <input type="submit"
									class="btn btn-primary" value="Create Project">
							</form>
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					</div>
				</div>

			</div>
		</div>
	</div>
	<div class="modal fade" id="myModal2" role="dialog">
		<div class="modal-dialog modal-lg">

			<!-- Modal content-->
			<div class="panel panel-info">
				<div class="panel panel-heading">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Rerun Sheet</h4>
				</div>
				<div class="panel panel-body">
					<form action='rerunSheet.jsp' method='post'>
						<input type="text" class="form-control" name="pname"
							placeholder="Project Name" /> <br /> <br /> <input type="text"
							name="s_id" class="form-control" style="float: right"
							placeholder="Sheet Id" /><br> <br> <input type="text"
							name="q_range" class="form-control" placeholder="Queries Range"
							value="Second!F12:F13" style="float: right" /><br> <br>
						<input type="text" name="op_range" class="form-control"
							placeholder="Output Range" value="Second!I12:I13"
							style="float: right" /><br> <br> <input
							type="checkbox" name='p_exec' value="p_exec" style="float: left">
						&nbsp;Parallel Exec <br> <br> <input type="submit"
							value="Rerun" class="btn btn-info"> <br>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
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
</script>
<script src="https://apis.google.com/js/client.js?onload=checkAuth">
	
</script>
</html>
