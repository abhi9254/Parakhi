<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.google.api.client.auth.oauth2.Credential"%>
<%@ page import="org.abhi.parakhi.SheetsAPI"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Parakhi - 0.7</title>

<link rel="stylesheet" href="/Parakhi/animate.css" type="text/css" />
<link rel="stylesheet" href="/Parakhi/css/bootstrap.min.css"
	type="text/css" />

<link rel="stylesheet" href="/Parakhi/style.css" type="text/css" />
<style>
</style>

<script type="text/javascript" src="/Parakhi/js/google_sheets_api.js"></script>
<script src="/Parakhi/js/jquery-3.1.1.min.js"></script>
<script src="/Parakhi/js/bootstrap.min.js"></script>
<script>
	function delCredentials(user_id) {
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax2.jsp?del_user_id=" + user_id, true)
		x.send(null)
		x.onreadystatechange =
				function() {
					if (x.readyState == 4) {
						document.getElementById("del_result").innerHTML =
								x.responseText;
					}
				}
	}
	function testConnection() {
		document.getElementById("con_test").innerHTML = "Checking.."
		connection_url = document.getElementById("connection_url").value;
		user = document.getElementById("user").value;
		pwd = document.getElementById("pwd").value;
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax2.jsp?connection_url=" + connection_url
				+ "&user=" + user + "&pwd=" + pwd, true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {
				document.getElementById("con_test").innerHTML = x.responseText;
			}
		}
	}
	function testHiveConnection() {
		document.getElementById("hive_con_test").innerHTML = "Checking.."
		hive_connection_url =
				document.getElementById("hive_connection_url").value;
		hive_user = document.getElementById("hive_user").value;
		hive_pwd = document.getElementById("hive_pwd").value;
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax2.jsp?hive_connection_url="
				+ hive_connection_url + "&hive_user=" + hive_user
				+ "&hive_pwd=" + hive_pwd, true)
		x.send(null)
		x.onreadystatechange =
				function() {
					if (x.readyState == 4) {
						document.getElementById("hive_con_test").innerHTML =
								x.responseText;
					}
				}

	}

	function fetchSheetDetails() {

		if (document.getElementById("sheet_url").value == "")
			document.getElementById("sheet_name").innerHTML = "Empty url";

		else {
			document.getElementById("sheet_name").innerHTML =
					"Retrieving spreadsheet details..";
			spreadsheet_id = document.getElementById("sheet_url").value;
			var x = new XMLHttpRequest()
			x.open("GET", "index_ajax2.jsp?title=1&spreadsheet_id="
					+ spreadsheet_id, true)
			x.send(null)
			x.onreadystatechange =
					function() {
						if (x.readyState == 4) {
							document.getElementById("sheet_name").innerHTML =
									x.responseText;
						}
					}
			document.getElementById("sheet_ws").innerHTML =
					"Checking worksheets..";
			fetchWorksheets();
		}
	}
	function fetchWorksheets() {

		spreadsheet_id = document.getElementById("sheet_url").value;
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax2.jsp?ws=1&spreadsheet_id=" + spreadsheet_id,
				true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {
				document.getElementById("sheet_ws").innerHTML = x.responseText;
			}
		}
	}
</script>
<meta charset="utf-8">
<title>Parakhi - 0.7</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta name="description" content="Parakhi" />
<!-- css -->
<link href="template_files/bootstrap.min.css" rel="stylesheet" />
<link href="template_files/style.css" rel="stylesheet" />
<link rel="stylesheet" href="css/style.css" type="text/css">
<style>
header .navbar {
	min-height: 51px;
}

header .navbar-nav>li {
	padding-bottom: 4px;
	padding-top: 5px;
}

.navbar-inverse {
	background-color: #353535;
	border-color: #080808;
}
</style>
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

	<div class="panel-group" id="accordion">

		<div class="panel panel-default">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a data-toggle="collapse" data-parent="#accordion"
						href="#collapse4" style="display: block; text-decoration: none">HiveServer</a>
				</h4>
			</div>
			<div id="collapse4" class="panel-collapse collapse">
				<div class="panel-body" style="margin-left: 10px">
					<h5>Toggle : HiveServer / HiveServer2</h5>
					<h5>Parallel Hive connections : 2 (current)</h5>
				</div>
			</div>
		</div>



		<div class="panel panel-default">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a data-toggle="collapse" data-parent="#accordion"
						href="#collapse1" style="display: block; text-decoration: none">Hive
						connection</a>
				</h4>
			</div>
			<div id="collapse1" class="panel-collapse collapse">
				<div class="panel-body" style="margin-left: 10px">

					<input type="text" class="form-control" id="hive_connection_url"
						placeholder="Hive connection url" style="width: 800px" /><br>
					<input type="text" class="form-control" id="hive_user"
						placeholder="user" style="width: 200px" /><br> <input
						type="password" class="form-control" id="hive_pwd"
						placeholder="password" style="width: 200px" /><br>

					<button class="btn btn-primary" onclick="testHiveConnection()"
						style="width: 80px">Check</button>

					<button class="btn btn-success" style="width: 80px" onclick="">Apply</button>
					<div id="hive_con_test"></div>
				</div>
			</div>
		</div>


		<div class="panel panel-default">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a data-toggle="collapse" data-parent="#accordion"
						href="#collapse0" style="display: block; text-decoration: none">MySql
						connection</a>
				</h4>
			</div>
			<div id="collapse0" class="panel-collapse collapse">
				<div class="panel-body" style="margin-left: 10px">
					<input type="text" class="form-control" id="connection_url"
						placeholder="MySql connection url" style="width: 800px" /> <br>
					<input type="text" class="form-control" id="user"
						placeholder="user" style="width: 200px" /> <br> <input
						type="password" class="form-control" id="pwd"
						placeholder="password" style="width: 200px" /><br>
					<button class="btn btn-primary" onclick="testConnection()"
						style="width: 80px">Check</button>

					<button class="btn btn-success" style="width: 80px" onclick="">Apply</button>
					<div id="con_test"></div>

				</div>
			</div>
		</div>



		<div class="panel panel-default">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a data-toggle="collapse" data-parent="#accordion"
						href="#collapse3" style="display: block; text-decoration: none">Google
						Authorization</a>
				</h4>
			</div>
			<div id="collapse3" class="panel-collapse collapse in">
				<div class="panel-body" style="margin-left: 10px">

					<div id="authorization-div" style="display: none"></div>
					<form action="Oauth2Servlet">
						<label> Authorize Parakhi to use Google sheets</label> <small>(Do not use Kohls account)</small><br> <input
							class="btn btn-primary" type="submit" value="Authorize" />
					</form>
					<br>

					<form action="delCredentials">
						<label>Manage Google permissions or Delete saved
							credentials</label><br> <a class="btn btn-warning" target="_blank"
							href="https://myaccount.google.com/permissions">Revoke
							Permission</a> <input class="btn btn-default" type="submit"
							value="Delete Saved Creds" />
					</form>


				</div>
			</div>
		</div>


		<div class="panel panel-default">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a data-toggle="collapse" data-parent="#accordion"
						href="#collapse2" style="display: block; text-decoration: none">Sheets
						connection</a>
				</h4>
			</div>
			<div id="collapse2" class="panel-collapse collapse">
				<div class="panel-body" style="margin-left: 10px">

					<input type="text" class="form-control" id="sheet_url"
						placeholder="Sheet url"
						value="https://docs.google.com/spreadsheets/d/16Fy4uF1MVpAkoW-ads6XabQnuOK2HJQ63mn7FUnNjkE/edit#gid=247511847"
						style="width: 800px; display: inline-block" /> <input
						type="button" class="btn btn-primary" value="Inspect"
						onclick="fetchSheetDetails()" /> <br>
					<div id="sheet_name"></div>
					<div id="sheet_ws"></div>

				</div>
			</div>
		</div>



	</div>

</body>
</html>