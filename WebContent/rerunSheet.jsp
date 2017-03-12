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
<script src="/Parakhi/js/jquery-3.1.1.min.js"></script>
<script src="/Parakhi/js/bootstrap.min.js"></script>
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
		<h4>Rerunning Sheet..</h4>
		<h4>Complete</h4>
	</div>

	<%
		String sheet_id = request.getParameter("selected_testsheet");
		String worksheet_id = request.getParameter("selected_worksheet");
		String token = (String) request.getSession().getAttribute("token");
		String q_range = worksheet_id + "!" + request.getParameter("q_range");
		String op_range = null;

		SheetsAPI ob = new SheetsAPI();

		if (request.getParameter("op_range") != null && request.getParameter("op_range") != "")
			op_range = worksheet_id + "!" + request.getParameter("op_range");
		else {
			int sep = request.getParameter("q_range").indexOf(':');
			String opRowStart = request.getParameter("q_range").substring(1, sep);
			op_range = worksheet_id + "!" + ob.getLastCol(token, sheet_id, worksheet_id) + opRowStart;
		}

		ob.rerunSheet(token, sheet_id, worksheet_id, q_range, op_range);
	%>

</body>
</html>