
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.google.api.client.auth.oauth2.Credential"%>
<%@ page
	import="java.io.PrintWriter,java.sql.DriverManager,java.sql.Connection,java.sql.ResultSet,java.sql.ResultSetMetaData,java.sql.Statement,java.sql.SQLException,java.util.regex.Matcher,java.util.regex.Pattern"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>Parakhi - 0.7</title>

<!-- css -->
<link href="template_files/bootstrap.min.css" rel="stylesheet" />
<link href="template_files/style.css" rel="stylesheet" />
<link href="template_files/bootstrap_multiselect.min.css"
	rel="stylesheet" type="text/css" />
<link rel="stylesheet" href="css/style.css" type="text/css" />

<script type="text/javascript" src="/Parakhi/js/google_sheets_api.js"></script>
<script type="text/javascript" src="/Parakhi/js/jquery-3.1.1.min.js"></script>
<script type="text/javascript" src="/Parakhi/js/bootstrap.min.js"></script>
<script type="text/javascript"
	src="/Parakhi/js/jquery.tablesorter.min.js"></script>


<script>
	$(document).ready(function() {
		$("#res_tbl").tablesorter();
	});
</script>
<script>
	function pushToSheet2() {

		var query = document.getElementById('query').innerHTML;
		var row_c = document.getElementById('res_tbl').rows.length;

		var i = 0, j = 0;
		var str = "";

		for (i = 0; i < row_c; i++) {
			str = str + "\n";

			var cell_c =
					document.getElementById("res_tbl").rows[i].cells.length;

			for (j = 0; j < cell_c - 1; j++) {

				var x =
						document.getElementById("res_tbl").rows[i].cells
								.item(j).innerHTML;

				str = str + x + "\t";

			}

		}

		var x = new XMLHttpRequest();
		var params = "query=" + query + "&result=" + str;
		x.open("POST", "index_ajax2.jsp", true);

		x.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
		x.onreadystatechange = function() {
			if (x.readyState == 4 && x.status == 200) {
				alert(x.responseText).trim();
			}
		}
		x.send(params);
	}

	function previewTraceQuery(tbl_nm) {

		var query_element =
				document.getElementById('query_' + tbl_nm).style.display
		if (query_element == 'none')
			document.getElementById('query_' + tbl_nm).style.display = 'inline'
		else
			document.getElementById('query_' + tbl_nm).style.display = 'none'
	}

	function traceRows(tbl_nm) {
		//	alert("in func " + tbl_nm)
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax2.jsp?trace_tbl_nm=" + tbl_nm, true)
		x.send(null)
		x.onreadystatechange =
				function() {
					if (x.readyState == 4) {
						document.getElementById("src_db_nms").innerHTML =
								x.responseText.trim();
					}
				}
		traceRows2();
	}

	function traceRows2() {
		var header_row = document.getElementById("row_0").cells;
		var headers = [];
		for (i = 1; i < header_row.length - 1; i++)
			headers.push(header_row[i].innerHTML);

		//alert(headers);

		// create trace forms for all source tables
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
		//	alert(tbl_arr)
		var track_creator = '';
		for (i = 0; i < tbl_arr.length; i++) {
			track_creator +=
					"<form action='Query' method='post' target='_blank' id='"+tbl_arr[i]+"'><label>"
							+ tbl_arr[i] + "</label><br></form><br>";

		}
		document.getElementById("tracker").innerHTML = track_creator;

		//create checkboxes for only those columns in resultset which are in stm, with a defined source
		for (h = 0; h < headers.length; h++) {
			//check the header in each table
			//alert(tbl_nms)
			for (i = 0; i < tbl_nms.length; i++) {
				//alert("in outer loop")
				var str = tbl_nms[i]
				//split to get tbl nms from stm
				var tbl_nm = str.substring(0, str.indexOf(' '))
				//split to get col nms from stm
				//	var src_col_nm = str.substring(str.indexOf(' ') + 1,str.indexOf('|'))
				var tgt_col_nm = str.substring(str.indexOf('|') + 1)
				var col_nm = str.substring(str.indexOf(' ') + 1)

				if (headers[h] == tgt_col_nm) {
					document.getElementById(tbl_nm).innerHTML +=
							"<input type='checkbox' style='display:inline-block' id='checkboxes_"
									+ tbl_nm + "' name='cols_" + tbl_nm
									+ "' value='" + col_nm
									+ "' checked='true' onchange=traceCols('"
									+ tbl_nm + "')></input>" + tgt_col_nm;
				}
			}
		}

		traceRows3(tbl_arr);
	}

	function traceRows3(tbl_arr) {

		for (i = 0; i < tbl_arr.length; i++) {
			var tbl_nm = tbl_arr[i];

			var checked_tgt_col = [];
			var checked_src_col = [];

			var checkboxes;
			if (tbl_nm != '') {
				checkboxes = document.getElementsByName('cols_' + tbl_nm);
				for (c = 0; c < checkboxes.length; c++) {
					if (checkboxes[c].checked) {
						str = checkboxes[c].value
						checked_src_col
								.push(str.substring(0, str.indexOf('|')))
						checked_tgt_col.push(str
								.substring(str.indexOf('|') + 1))
					}
				}
			}
			//alert(checked_src_col);alert(checked_tgt_col);
			var header_row = document.getElementById("row_0").cells;
			var headers = [];
			for (e = 1; e < header_row.length - 1; e++)
				headers.push(header_row[e].innerHTML);

			var data_rows = document.getElementsByName("trace");
			var data_rows_id = [];
			for (r = 0; r < data_rows.length; r++) {
				if (data_rows[r].checked)
					data_rows_id.push(data_rows[r].value);
			}
			var query = "select * from " + tbl_nm;

			if (checked_tgt_col.length != 0) {

				for (d = 0; d < data_rows_id.length; d++) {
					var data_row =
							document.getElementById(data_rows_id[d]).cells
					for (h = 0; h < checked_tgt_col.length; h++) {
						if (h == 0) {
							for (j = 0; j < headers.length; j++) {
								if (checked_tgt_col[0] == headers[j]) {
									if (d == 0)
										query +=
												" WHERE \n("
														+ checked_src_col[0]
														+ " = '"
														+ data_row[j + 1].innerHTML
														+ "'"
									else
										query +=
												"\n("
														+ checked_src_col[0]
														+ " = '"
														+ data_row[j + 1].innerHTML
														+ "'"
									if (checked_tgt_col.length == 1
											&& d != data_rows_id.length - 1)
										query += ") OR"
									if (checked_tgt_col.length == 1
											&& d == data_rows_id.length - 1)
										query += ")"
									break;
								}
							}

						} else {
							for (j = 0; j < headers.length; j++) {
								if (checked_tgt_col[h] == headers[j]) {
									query +=
											" AND " + checked_src_col[h]
													+ " = '"
													+ data_row[j + 1].innerHTML
													+ "'"
									if (h == checked_tgt_col.length - 1
											&& d != data_rows_id.length - 1)
										query += ") OR"
									if (h == checked_tgt_col.length - 1
											&& d == data_rows_id.length - 1)
										query += ")"
									break;
								}
							}
						}
					}
				}

				//turn display: inline to debug
				document.getElementById(tbl_nm).innerHTML +=
						"<textarea id=query_"
								+ tbl_nm
								+ " style='display:none;width:50%;height:100px' name = 'query_text'>"
								+ query
								+ "</textarea><input type='submit' value='Trace' class='btn btn-info' style='float: right; display:inline-block'><input type='button' value='Preview' onclick=previewTraceQuery('"
								+ tbl_nm
								+ "') class='btn' style='float: right;display:inline-block'/>"

			}
		}
	}
	//WORKING CTRL Z CHECK

	function traceCols(tbl_nm) {
		var checkboxes;
		var checked_tgt_col = [];
		var checked_src_col = [];

		//get headers of resultset
		var header_row = document.getElementById("row_0").cells;
		var headers = [];
		for (i = 1; i < header_row.length - 1; i++)
			headers.push(header_row[i].innerHTML);
		//	alert(headers)

		// get selected rows via checkbox
		var data_rows = document.getElementsByName("trace");
		var data_rows_id = [];
		for (i = 0; i < data_rows.length; i++) {
			if (data_rows[i].checked)
				data_rows_id.push(data_rows[i].value);
		}

		//alert(data_rows_id)

		if (tbl_nm != '') {

			var query = "select * from " + tbl_nm
			checkboxes = document.getElementsByName('cols_' + tbl_nm);
			for (c = 0; c < checkboxes.length; c++) {
				if (checkboxes[c].checked) {
					str = checkboxes[c].value
					checked_src_col.push(str.substring(0, str.indexOf('|')))
					checked_tgt_col.push(str.substring(str.indexOf('|') + 1))
				}
			}

			if (checked_tgt_col.length != 0) {
				for (d = 0; d < data_rows_id.length; d++) {
					var data_row =
							document.getElementById(data_rows_id[d]).cells
					for (h = 0; h < checked_tgt_col.length; h++) {
						if (h == 0) {
							for (j = 0; j < headers.length; j++) {
								if (checked_tgt_col[0] == headers[j]) {
									if (d == 0)
										query +=
												" WHERE \n("
														+ checked_src_col[0]
														+ " = '"
														+ data_row[j + 1].innerHTML
														+ "'"
									else
										query +=
												"\n("
														+ checked_src_col[0]
														+ " = '"
														+ data_row[j + 1].innerHTML
														+ "'"
									if (checked_tgt_col.length == 1
											&& d != data_rows_id.length - 1)
										query += ") OR"
									if (checked_tgt_col.length == 1
											&& d == data_rows_id.length - 1)
										query += ")"
									break;
								}
							}

						} else {
							for (j = 0; j < headers.length; j++) {
								if (checked_tgt_col[h] == headers[j]) {
									query +=
											" AND " + checked_src_col[h]
													+ " = '"
													+ data_row[j + 1].innerHTML
													+ "'"
									if (h == checked_tgt_col.length - 1
											&& d != data_rows_id.length - 1)
										query += ") OR"
									if (h == checked_tgt_col.length - 1
											&& d == data_rows_id.length - 1)
										query += ")"
									break;
								}
							}
						}
					}
				}
				//	alert(query)
				document.getElementById('query_' + tbl_nm).innerHTML = query;
			}

			else
				document.getElementById('query_' + tbl_nm).innerHTML = '';

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

	<header>
	<div class="navbar navbar-inverse navbar-static-top">
		<small style="color: white">Project: <%=request.getSession().getAttribute("proj_nm")%>,
		</small>
		<%
			Credential credential = (Credential) request.getSession().getAttribute("credential");

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


	<br>
	<input type="button" name="back" class="back-button" value="< Back"
		onclick="history.back()">
	<!-- Push function defined in google api js -->
	<input type="button" id="push-div" onclick="pushToSheet2()"
		class="push-button" style="display: inline" value="Push Result">
	<!-- Do not change this buttons ID -->
	<button id="authorize-div" class="push-button" style="display: none"
		onclick="handleAuthClick(event)">Authorize to push</button>

	<button id="trace-div" class="push-button" style="display: inline"
		href="" onmouseover="traceRows2()" data-toggle="modal"
		data-target="#traceModal">Trace</button>

	<pre id="output" style="display: none">Working..</pre>
	<br>
	<br>
	<%
		String query = request.getAttribute("user_query").toString();
		String queried_tbl;

		Pattern pattern = Pattern.compile("from (.+?)\\.(.+?)\\b");
		Matcher matcher = pattern.matcher(query);
		if (matcher.find())
			queried_tbl = matcher.group().substring(matcher.group().indexOf(' ') + 1);
		else
			queried_tbl = null;
	%>
	<ul class="tab">
		<li><a href="javascript:void(0)" class="tablinks"
			onclick="openTab(event, 'Query')" id="defaultOpen">Query</a></li>
		<li><a href="javascript:void(0)" class="tablinks"
			onclick="openTab(event, 'Result')"
			onmouseover="traceRows('<%=queried_tbl%>')">Result</a></li>
		<li><a href="javascript:void(0)" class="tablinks"
			onclick="openTab(event, 'Log')">Log</a></li>
	</ul>

	<div id="Query" class="tabcontent">

		<pre id="query"><%=query%></pre>
		<pre id="queried_tbl" style="display: none"><%=queried_tbl%></pre>
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
					<!-- stores stm source tbls,cols -->
					<label id="src_db_nms" style="display: none">src_db_nms</label>

					<div id="tracker"></div>

				</div>
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
			tablinks[i].className =
					tablinks[i].className.replace(" active", "");
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
