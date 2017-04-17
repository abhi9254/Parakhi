<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.abhi.parakhi.SheetsAPI"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Parakhi - 0.7</title>
<link rel="stylesheet" href="/Parakhi/style.css" type="text/css">
<link rel="stylesheet" href="/Parakhi/animate.css" type="text/css">
<link rel="stylesheet" href="/Parakhi/css/bootstrap.min.css"
	type="text/css">
<script type="text/javascript" src="/Parakhi/js/google_sheets_api.js"></script>
<script src="/Parakhi/js/jquery-3.1.1.min.js"></script>
<script src="/Parakhi/js/bootstrap.min.js"></script>
<script>
	function delCredentials(user_id) {
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax2.jsp?del_user_id=" + user_id, true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {
				document.getElementById("del_result").innerHTML = x.responseText;
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
		hive_connection_url = document.getElementById("hive_connection_url").value;
		hive_user = document.getElementById("hive_user").value;
		hive_pwd = document.getElementById("hive_pwd").value;
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax2.jsp?hive_connection_url="
				+ hive_connection_url + "&hive_user=" + hive_user
				+ "&hive_pwd=" + hive_pwd, true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {
				document.getElementById("hive_con_test").innerHTML = x.responseText;
			}
		}

	}

	function fetchSheetDetails() {

		if (document.getElementById("sheet_url").value == "")
			document.getElementById("sheet_name").innerHTML = "Empty url";

		else {
			document.getElementById("sheet_name").innerHTML = "Retrieving spreadsheet details..";
			spreadsheet_id = document.getElementById("sheet_url").value;
			var x = new XMLHttpRequest()
			x.open("GET", "index_ajax2.jsp?title=1&spreadsheet_id="
					+ spreadsheet_id, true)
			x.send(null)
			x.onreadystatechange = function() {
				if (x.readyState == 4) {
					document.getElementById("sheet_name").innerHTML = x.responseText;
				}
			}
			document.getElementById("sheet_ws").innerHTML = "Checking worksheets..";
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
<title>Parakhi - Making Testing So EASY</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta name="description" content="Parakhi" />
<!-- css -->
<link href="template_files/bootstrap.min.css" rel="stylesheet" />
<link href="template_files/style.css" rel="stylesheet" />
<link rel="stylesheet" href="css/style.css" type="text/css">
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
							<li><a href="index.jsp" data-toggle="modal">Switch
									Project</a></li>
							<li><a href="index.jsp">New Project</a></li>
						</ul></li>
					<li class="dropdown"><a href="#" class="dropdown-toggle"
						data-toggle="dropdown" data-hover="dropdown" data-delay="0"
						data-close-others="false" style="color: white">Sheets <span
							class="glyphicon glyphicon-chevron-down"></span></a>
						<ul class="dropdown-menu">
							<li><a target="_blank"
								href="https://docs.google.com/spreadsheets/d/16Fy4uF1MVpAkoW-ads6XabQnuOK2HJQ63mn7FUnNjkE">View
									Sheet</a></li>
							<li><a href="index.jsp" data-toggle="modal"
								data-target="#myModal2">Rerun Sheet</a></li>
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
	<div style="margin-left: 10px">
	
		<br>
		<h3>Toggle: HiveServer / HiveServer2</h3>
		<h3>Set parallelism: Current= 2</h3>
	</div>
	<div style="margin-left: 10px">
		<h4>Test Mysql connection</h4>
		<input type="text" id="connection_url" placeholder="connection url"
			style="width: 500px" /><br> <br> <input type="text"
			id="user" placeholder="user" /><br> <br> <input
			type="password" id="pwd" placeholder="password" /><br> <br>
		<button onclick="testConnection()">Check</button>
		<br>
		<div id="con_test"></div>

	</div>
	<div style="margin-left: 10px">
		<h4>Test Hive connection</h4>
		<input type="text" id="hive_connection_url"
			placeholder="connection url" style="width: 500px" /><br> <br>
		<input type="text" id="hive_user" placeholder="user" /><br> <br>
		<input type="password" id="hive_pwd" placeholder="password" /><br>
		<br>
		<button onclick="testHiveConnection()">Check</button>
		<br>
		<div id="hive_con_test"></div>
	</div>
	<div style="margin-left: 10px">
		<h4>Test Sheets connection</h4>
		<input type="text" id="sheet_url" placeholder="Sheet url"
			value="https://docs.google.com/spreadsheets/d/16Fy4uF1MVpAkoW-ads6XabQnuOK2HJQ63mn7FUnNjkE/edit#gid=247511847"
			style="width: 800px; display: inline-block" /> <input type="button"
			value="Inspect" onclick="fetchSheetDetails()" /> <br>
		<div id="sheet_name"></div>
		<div id="sheet_ws"></div>
		<br> <br>
	</div>
	<div id="authorization-div" style="display: none"></div>
	<form action="Oauth2Servlet" style="display: inline">
		<input type="submit" value="Authorize" />
	</form>
	<form action="delCredentials" style="display: inline">
		<input type="submit" value="Delete Saved Creds" />
	</form>


</body>
</html>