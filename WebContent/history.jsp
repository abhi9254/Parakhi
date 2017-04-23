<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.google.api.client.auth.oauth2.Credential"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Parakhi - 0.7</title>
<link rel="stylesheet" href="/Parakhi/style.css" type="text/css">
<link rel="stylesheet" href="/Parakhi/animate.css" type="text/css">
<link rel="stylesheet" href="/Parakhi/css/bootstrap.min.css"
	type="text/css">
<script src="/Parakhi/js/jquery-3.1.1.min.js"></script>
<script src="/Parakhi/js/bootstrap.min.js"></script>
<meta charset="utf-8">
<title>Parakhi - 0.7</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta name="description" content="Parakhi" />
<!-- css -->
<link href="template_files/bootstrap.min.css" rel="stylesheet" />
<link href="template_files/style.css" rel="stylesheet" />
<link rel="stylesheet" href="css/style.css" type="text/css">
<script>
	function getTasks() {

		$.get("index_ajax2.jsp?tasks=1", function(data) {

			$('#results').html(data);
		});

		setInterval(function() {

			$.get("index_ajax2.jsp?tasks=1", function(data) {

				$('#results').html(data);
			});
		}, 10000);

	}
</script>


</head>
<body onload="getTasks()">
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

	<h2 style="margin-left: 20px">Recent Tasks</h2>

	<div style="margin-left: 20px; width: 30%">


		<h4>110881: Rerun Sheet Task</h4>
		<div class="progress">
			<div class="progress-bar  progress-bar-danger" role="progressbar"
				aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"
				style="width: 100%">Failed</div>
		</div>

		<!-- <button class="btn btn-info" style="display: inline ;float:right">Remove</button>
		 -->

		<h3 id='results'>Updating..</h3>
	</div>
</body>
</html>