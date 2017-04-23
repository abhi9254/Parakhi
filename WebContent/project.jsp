<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.google.api.client.auth.oauth2.Credential"%>
<%@ page
	import="org.abhi.parakhi.MySQL_dao,java.util.ArrayList,java.util.List"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Parakhi - 0.7</title>
<link rel="stylesheet" href="/Parakhi/style.css" type="text/css">
<link rel="stylesheet" href="/Parakhi/animate.css" type="text/css">
<link rel="stylesheet" href="/Parakhi/css/bootstrap.min.css"
	type="text/css">
<link rel="stylesheet" href="/Parakhi/css/w3.css" type="text/css">
<style>
#myInput {
	background-image: url('res/images/search.svg');
	background-size: 20px 20px;
	/* Add a search icon to input */
	background-position: 10px 14px; /* Position the search icon */
	background-repeat: no-repeat; /* Do not repeat the icon image */
	width: 100%; /* Full-width */
	font-size: 16px; /* Increase font-size */
	padding: 12px 20px 12px 40px; /* Add some padding */
	border: 0px;
	border-right:1px solid #ddd; /* Add a grey border */
	margin-bottom: 12px; /* Add some space below the input */
}
</style>
<script src="/Parakhi/js/jquery-3.1.1.min.js"></script>
<script src="/Parakhi/js/bootstrap.min.js"></script>
<script>
function showProjectDetails(proj_id){
	document.getElementById("tables_list").innerHTML='';
	var x = new XMLHttpRequest()
	x.open("GET", "index_ajax2.jsp?tables=1&proj_id=" + proj_id,
			true)
	x.send(null)
	x.onreadystatechange = function() {
		if (x.readyState == 4) {
			document.getElementById("tables_list").innerHTML = x.responseText;
		}
	}
	
	var y = new XMLHttpRequest()
	y.open("GET", "index_ajax2.jsp?testsheets=1&proj_id=" + proj_id,
			true)
	y.send(null)
	y.onreadystatechange = function() {
		if (y.readyState == 4) {
			document.getElementById("testsheets_list").innerHTML = y.responseText;
		}
	}
	
	var z = new XMLHttpRequest()
	z.open("GET", "index_ajax2.jsp?stmsheets=1&proj_id=" + proj_id,
			true)
	z.send(null)
	z.onreadystatechange = function() {
		if (z.readyState == 4) {
			document.getElementById("stmsheets_list").innerHTML = z.responseText;
		}
	}
}

function myFunction(id) {
    var x = document.getElementById(id);
    if (x.className.indexOf("w3-show") == -1) {
        x.className += " w3-show";
        x.previousElementSibling.className = 
        x.previousElementSibling.className.replace("w3-sand", "w3-light-grey");
    } else { 
        x.className = x.className.replace(" w3-show", "");
        x.previousElementSibling.className = 
        x.previousElementSibling.className.replace("w3-light-grey", "w3-sand");
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
								<li><a href="" data-toggle="modal" data-target="#verifyddl">Verify
										DDLs</a></li>
							</ul></li>

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


	<ul class="ver_nav_bar" id="projects_ul">
		<input type="text" id="myInput" onkeyup="myFunction()"
			placeholder="Search...">
		<%
			MySQL_dao ob = new MySQL_dao();
			List<String[]> projects = new ArrayList<String[]>(ob.getProjects());
			for (int i = 0; i < projects.size(); i++) {
		%>
		<li class="ver_li" title="<%=projects.get(i)[2]%>"><a
			class="ver_li inactive" href="#"
			onclick="showProjectDetails(<%=projects.get(i)[0]%>)"
			style="font-size: large"><%=projects.get(i)[1]%></a></li>

		<%
			}
		%>
	</ul>



	<div class="panel-group" id="accordion" style="margin-left: 15.5%;margin-top:10px">

		<div class="panel panel-default">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a data-toggle="collapse" data-parent="#accordion"
						href="#collapse1" style="display: block; text-decoration: none">About</a>
				</h4>
			</div>
			<div id="collapse1" class="panel-collapse collapse in">
				<div id="about"
					style="width: 40%; padding: 10px; margin: 0px; display: inline-block; float: top">Select
					a project..</div>
			</div>
		</div>

		<div class="panel panel-default">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a data-toggle="collapse" data-parent="#accordion"
						href="#collapse2" style="display: block; text-decoration: none">STMs</a>
				</h4>
			</div>
			<div id="collapse2" class="panel-collapse collapse">
				<div id="stmsheets_list"
					style="width: 40%; padding: 10px; margin: 0px; display: inline-block; float: top">Select
					a project..</div>
				<a href="" style="float: right; margin-right: 50px">Add</a><br>
			</div>
		</div>

		<div class="panel panel-default">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a data-toggle="collapse" data-parent="#accordion"
						href="#collapse3" style="display: block; text-decoration: none">Test
						Sheets</a>
				</h4>
			</div>
			<div id="collapse3" class="panel-collapse collapse">
				<div id="testsheets_list"
					style="width: 40%; padding: 10px; margin: 0px; display: inline-block; float: top">Select
					a project..</div>
				<a href="" style="float: right; margin-right: 50px">Add</a><br>
			</div>
		</div>


		<div class="panel panel-default">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a data-toggle="collapse" data-parent="#accordion"
						href="#collapse4" style="display: block; text-decoration: none">Tables</a>
				</h4>
			</div>
			<div id="collapse4" class="panel-collapse collapse">
				<div id="tables_list"
					style="width: 40%; padding: 10px; margin: 0px; display: inline-block; float: top">Select
					a project..</div>
			</div>
		</div>


	</div>


</body>

</html>