<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.abhi.parakhi.MySQL_dao"%>
<%@ page import="java.util.List,java.util.ArrayList"%>

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
<script type="text/javascript">
	function getTables() {
		//document.getElementById('table').innerHTML = "<option selected disabled value=''>Table</option>";
		var db_nm = document.getElementById('database').value;
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax2.jsp?tbl_nms=1&db_nm=" + db_nm, true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {
				document.getElementById("table").innerHTML = x.responseText;
				document.getElementById("columns").innerHTML = "";
			}
		}
	}
	function getColumns() {
		var tbl_nm = document.getElementById('table').value;
		var db_nm = document.getElementById('database').value;
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax2.jsp?col_nms=1&db_nm=" + db_nm + "&tbl_nm="
				+ tbl_nm, true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {
				document.getElementById("columns").innerHTML = x.responseText;
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
	<br>

	<div class="container">
		<div class="row">
			<div class="panel panel-warning">
				<div class="panel panel-heading">DATA FIT</div>
				<div class="panel panel-body">
					<form action="Cross_section_mt" method="post">
						<select class="form-control" id="database" name="database"
							onchange='getTables()'>
							<option selected disabled value=''>Database</option>
							<%
								MySQL_dao ob = new MySQL_dao();
								int proj_id = 0;
								if (request.getSession().getAttribute("proj_id") != null)
									proj_id = Integer.parseInt(request.getSession().getAttribute("proj_id").toString());
								List<String> db_nms = new ArrayList<String>(ob.getProjDbNames(proj_id));
								for (String db_nm : db_nms) {
							%>
							<option value="<%=db_nm%>"><%=db_nm%></option>
							<%
								}
							%>
						</select> <br> <select class="form-control" name="table" id='table'
							onchange='getColumns()'>
							<option selected disabled value=''>Table</option>
						</select> <br>
						<div id='columns'>
						</div>
						<br> <input type="submit" value="Brinng it"
							class="btn btn-warning">
					</form>
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
</html>