<%@page import="java.sql.PreparedStatement"%>
<%@page import="com.google.api.client.auth.oauth2.Credential"%>
<%@page import="java.util.List,java.util.ArrayList"%>
<%@ page import="org.abhi.parakhi.MySQL_dao,org.abhi.parakhi.SheetsAPI"%>
<%@page
	import="com.google.api.client.googleapis.auth.oauth2.GoogleCredential"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.sql.*,java.util.HashMap"%>

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


<style>
.leftSection {
	font-size: large;
	color: red;
	padding: 3px;
	margin-top: 3px;
	border-style: groove;
	border-width: 2px;
	border-radius: 4px;
	opacity: 1.0;
	background-color: white;
}

.leftSection a:hover {
	background-color: white;
}

.sidebar-nav {
	padding: 9px 0;
}

.dropdown-menu {
	background-color: white;
}

.dropdown-menu .sub-menu {
	background-color: white;
	left: 100%;
	position: absolute;
	top: 0;
	visibility: hidden;
	margin-top: -2px;
}

.dropdown-menu li:hover .sub-menu {
	visibility: visible;
}

.dropdown:hover .dropdown-menu {
	display: block;
}

.nav-tabs .dropdown-menu, .nav-pills .dropdown-menu, .navbar .dropdown-menu
	{
	margin-top: 0;
}

.navbar .sub-menu:before {
	border-bottom: 7px solid;
	border-left: none;
	border-right: 7px solid rgba(0, 0, 0, 0.2);
	border-top: 7px solid;
	left: -7px;
	top: 10px;
}

.navbar .sub-menu:after {
	border-top: 6px solid;
	border-left: none;
	border-right: 6px solid #fff;
	border-bottom: 6px solid;
	left: 10px;
	top: 11px;
	left: -6px;
}

#myInput {
	background-image: url('css/search.svg');
	background-size: 22px 22px;
	/* Add a search icon to input */
	background-position: 10px 12px; /* Position the search icon */
	background-repeat: no-repeat; /* Do not repeat the icon image */
	width: 100%; /* Full-width */
	font-size: 16px; /* Increase font-size */
	padding: 12px 20px 12px 40px; /* Add some padding */
	border: 1px solid #ddd; /* Add a grey border */
	margin-bottom: 12px;
	background-repeat: no-repeat /* Add some space below the input */
}

.chosen-container-multi .chosen-choices {
	overflow: initial;
	border: 0px;
}

.chosen-container-single .chosen-single span {
	overflow: initial;
	border: 0px;
}
</style>
<script src="js/jquery-3.1.1.min.js" type="text/javascript"></script>
<script src="js/bootstrap.min.js" type="text/javascript"></script>
<script src="js/chosen.jquery.min.js" type="text/javascript"></script>
<script>
	function dothat() {
		$(document).ready(function() {
			$(".chosen-select").chosen();
			$('button').click(function() {
				$(".chosen-select").val('').trigger("chosen:updated");
			});

			var q = document.getElementById('query_text').value;
			var q2 = document.getElementById('query_text').value;
			$('#tables').on('change', function(evt, params) {
				var selected = $(this).val();
				var up_q = q.replace(' $db.$tableA ', " " + selected + " ");
				document.getElementById('query_text').value = up_q;
				q2 = up_q;
				dotheotherone(selected, up_q)
			});

			$('#columns').on('change', function(evt, params) {

				var cols = $(this).val();
				var up_q2 = q2.replace(' $tableA.$cols ', " " + cols + " ");
				document.getElementById('query_text').value = up_q2;

			});
		});

	}

	function dotheotherone(selected, up_q) {

		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax.jsp?col_nms=1" + "&selected=" + selected,
				true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {
				var cols_list = x.responseText;
				//var final_q = up_q.replace('$tableA.$cols',cols_list);alert(final_q)
				var p = document.getElementById("makeQuery").innerHTML;
				var tbl_ptrn = /[$]tableA.[$]col./g;
				var q = p.replace(tbl_ptrn, cols_list);
				document.getElementById("makeQuery").innerHTML = q;
				//.replace('$tableA.$cols', cols_list);
				dothat();
			}
		}

	}
</script>
<script>
	function setActiveProj(proj_id, proj_nm) {
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax2.jsp?setProj=1&proj_id=" + proj_id
				+ "&proj_nm=" + proj_nm, true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {

			}
		}
	}
	function myFunction() {
		// Declare variables
		var input, filter, ul, li, a, i;
		input = document.getElementById('myInput');
		filter = input.value.toUpperCase();
		ul = document.getElementById("cases_ul");
		li = ul.getElementsByTagName('li');

		// Loop through all list items, and hide those who don't match the search query
		for (i = 0; i < li.length; i++) {
			a = li[i].getElementsByTagName("a")[0];
			if (a.innerHTML.toUpperCase().indexOf(filter) > -1) {
				//alert(i)
				li[i].style.display = "";
			} else {
				li[i].style.display = "none";
			}
		}
	}

	function enterQuery(inpQuery, projId) {
		document.getElementById("makeQuery").display = 'none';
		document.getElementById("query_text").innerHTML = ""
		var str = inpQuery.replace('$empty', '\'\'')
		if (projId == '')
			projId = 0

		document.getElementById("setQuery").value = str
		document.getElementById("query_text").value = str
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax.jsp?inpQuery=" + inpQuery + "&projId="
				+ projId, true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {
				document.getElementById("makeQuery").innerHTML = x.responseText;
				dothat();
				document.getElementById("makeQuery").display = 'inline';
			}
		}
	}

	function setQueryTblVal(db_nm, tbl_nm, tbl_nm_id, col_id, proj_id) {
		var Query = document.getElementById("setQuery").value
		//alert(Query)
		var finalQuery = ""
		if (document.getElementById(tbl_nm_id).innerHTML
				.match("[$]db.[$]table[A-Z]")) {
			document.getElementById(tbl_nm_id).innerHTML = db_nm + "." + tbl_nm
					+ "<b class='caret'></b>"
			//finalQuery=document.getElementById("query_text").value.replace(tbl_nm_id,"<span id='"+tbl_nm_id+"query_text'>"+db_nm+"."+tbl_nm+"</span>")
		} else {
			document.getElementById(tbl_nm_id).innerHTML = db_nm + "." + tbl_nm
					+ "<b class='caret'></b>"
			//document.getElementById(tbl_nm_id+"query_text").innerHTML = db_nm+"."+tbl_nm
		}

		if (Query.includes("$dateformat")) {
			var Query1 = Query.replace("$dateformat", "\'YYYY-MM-DD\'")
			Query = Query1
		}
		finalQuery = Query.replace(tbl_nm_id, db_nm + "." + tbl_nm)
		document.getElementById("query_text").value = finalQuery
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax.jsp?db_nm=" + db_nm + "&tbl_nm=" + tbl_nm
				+ "&col_id=" + col_id + "&proj_id=" + proj_id + "&check=col",
				true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {
				var elems = document.getElementsByTagName("span");
				var cols = x.responseText.split(",")
				var finalCols = ""
				for (var i = 0; i < elems.length; i++) {
					if (elems[i].id.includes(col_id)) {
						finalCols = ""
						for (var j = 0; j < cols.length - 1; j++) {
							finalCols = finalCols
									+ "<a href='#' onclick=setQueryColValue('"
									+ elems[i].id + "','" + cols[j] + "')>"
									+ cols[j] + "</a>" + ",";
						}
						document.getElementById(elems[i].id).innerHTML = finalCols
								.substring(0, finalCols.length - 1);

					}
				}
			}

		}
	}

	function setQueryColValue(col_id, colValue) {
		document.getElementById("fullCols").innerHTML = document
				.getElementById("fullCols").innerHTML
				+ colValue + ",";
		document.getElementById("colId").value = col_id
	}

	function addColumns() {
		var cols = document.getElementById("fullCols").innerHTML
		var colId = document.getElementById("colId").value
		cols = cols.substring(0, cols.length - 1)
		var query = document.getElementById("query_text").value.replace(colId,
				cols)
		document.getElementById("query_text").value = query
		document.getElementById("fullCols").innerHTML = ""
	}

	function resetColumns() {
		document.getElementById("fullCols").innerHTML = ""

	}

	function editQuery() {
		if (document.getElementById("query_text").style.display == "none") {
			document.getElementById("query_text").style.display = "inline-block"
			document.getElementById("main_panel").style.display = "none"
		} else {
			document.getElementById("query_text").style.display = "none"
			document.getElementById("main_panel").style.display = "inline-block"
		}
	}

	function fetchSheetDetails(url_type) {

		if (document.getElementById(url_type + "_url").value == "")
			document.getElementById(url_type + "_name").innerHTML = "Empty url";

		else {
			//	document.getElementById(url_type + "_name").innerHTML = "Retrieving spreadsheet details..";
			spreadsheet_id = document.getElementById(url_type + "_url").value;
			document.getElementById(url_type + "_url").value = "Retrieving spreadsheet details..";
			var x = new XMLHttpRequest()
			x.open("GET", "index_ajax2.jsp?title=1&spreadsheet_id="
					+ spreadsheet_id, true)
			x.send(null)
			x.onreadystatechange = function() {
				if (x.readyState == 4) {
					//	document.getElementById(url_type + "_name").innerHTML = x.responseText
					document.getElementById(url_type + "_url").value = x.responseText;
				}
			}
		}
	}
	function hideDiv(divName) {
		if (divName == 'excel') {
			document.getElementById("excel").style.display = "none";
			document.getElementById("google").style.display = "inline-block";
		}
		if (divName == 'google') {
			document.getElementById("google").style.display = "none";
			document.getElementById("excel").style.display = "inline-block";
		}
	}

	function getTestSheets() {
		var sel_proj = document.getElementById("selected_project").value;
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax2.jsp?testsheets=1&p_id=" + sel_proj, true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {
				//	document.getElementById(url_type + "_name").innerHTML = x.responseText
				document.getElementById("selected_testsheet").innerHTML = x.responseText;
				document.getElementById("selected_worksheet").innerHTML = "<option selected disabled>Worksheet Name</option>";
			}
		}

	}
	function getWorkSheets() {
		var sel_ts = document.getElementById("selected_testsheet").value;
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax2.jsp?worksheets=1&s_id=" + sel_ts, true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {
				//	document.getElementById(url_type + "_name").innerHTML = x.responseText
				document.getElementById("selected_worksheet").innerHTML = x.responseText;

			}
		}
	}
</script>
</head>
<body>
	<input type="text" hidden="hidden" id="setQuery">
	<input type="text" hidden="hidden" id="colId">

	<div id="wrapper">
		<!-- start header -->
		<header>
		<div class="navbar navbar-inverse navbar-static-top">
			<label style="color: white">Project: <%=request.getSession().getAttribute("proj_nm")%>,
			</label>
			<%
				Credential credential = (Credential) request.getSession().getAttribute("credential");

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




		<div class="ver_nav_bar">
			<input type="text" id="myInput" onkeyup="myFunction()"
				placeholder="Search for queries...">

			<ul class="nav nav-tabs">
				<li class="active" style="width: 50%"><a data-toggle="tab"
					href="#generic">Generic</a></li>
				<li style="width: 50%"><a data-toggle="tab" href="#project">Project</a></li>
			</ul>
			<div class="tab-content">
				<div id="generic" class="tab-pane fade in active">
					<ul class="ver_nav_bar" id="cases_ul">
						<%
							MySQL_dao ob = new MySQL_dao();
							List<String[]> cases = new ArrayList<String[]>(ob.getCases(0));

							for (String[] c : cases) {
						%>
						<li class="ver_li" title="<%=c[2]%>"><a
							class="ver_li inactive" href="#"
							onclick="enterQuery('<%=c[3]%>','0')" style="font-size: large"><%=c[1]%></a></li>

						<%
							}
						%>

					</ul>
				</div>

				<div id="project" class="tab-pane fade">
					<ul class="ver_nav_bar" id="cases_ul">
						<%
							int active_proj = Integer.parseInt(request.getSession().getAttribute("proj_id").toString());
							List<String[]> proj_cases = new ArrayList<String[]>(ob.getCases(active_proj));

							for (String[] c : proj_cases) {
						%>
						<li class="ver_li" title="<%=c[2]%>"><a
							class="ver_li inactive" href="#"
							onclick="enterQuery('<%=c[3]%>','<%=active_proj %>')" style="font-size: large"><%=c[1]%></a></li>

						<%
							}
						%>
					</ul>
				</div>

			</div>
		</div>
		<div id='clipboard'
			style="border: 1px solid black; float: right; height: 500px; width: 200px">Clipboard</div>
		<div class="container-fluid">
			<div class="row">
				<div class="col-md-2"></div>
				<div class="col-md-6">
					<form action="Query" method="post" style="margin-top: 10px">
						<div class="panel" id="main_panel"
							style="height: 200px; width: 600px; display: inline-block">
							<div id="makeQuery" class="panel panel-body"
								style="font-size: large; height: 200px; width: 600px; display: inline-block"></div>

						</div>


						<textarea name="query_text" id="query_text" cols="100" rows="5"
							style="font-size: large; font-color: black; border: 1px solid #A9A9A9; border-left: 4px solid #A9A9A9; border-radius: 0px; height: 200px; display: none">select * from db_gold.gold_product_sku</textarea>

						<input class="btn btn-success btn-lg" type="submit"
							style="display: inline-block; vertical-align: top; height: 200px; width: 80px"
							value="Fire" />
					</form>
					<button style="display: inline-block" onclick="editQuery();">Toggle
						Edit</button>
				</div>

			</div>
		</div>


		<div class="modal fade" id="onSwitchModal" role="dialog"
			style="display: none; margin-top: 60px;">
			<div class="modal-heading"
				style="text-align: center; background-color: #026c94">
				<h1 style="color: white">Existing Projects</h1>
			</div>
			<div class="modal-dialog">
				<div class="modal-content" style="background-color: #026c94">

					<div class="modal-body">
						<%
							List<String[]> projs = new ArrayList<String[]>(ob.getProjects());

							for (String[] p : projs) {
						%>

						<h4>
							<a title="<%=p[2]%>" href="index.jsp?q=<%=p[0]%>"
								style="color: white"
								onclick="setActiveProj('<%=p[0]%>','<%=p[1]%>')"><%=p[1]%></a>
						</h4>
						<%
							}
						%>
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

						<div class="panel panel-body">
							<ul class="nav nav-tabs" style="border-bottom: none;">
								<li class="active" style="background-color: white; padding: 0px"><a
									data-toggle="tab" href="#google" onclick="hideDiv('excel')"
									style="color: black; background-color: white">Google sheet</a></li>
								<li style="background-color: white; padding: 0px"><a
									data-toggle="tab" href="#excel" onclick="hideDiv('google')"
									style="color: black; background-color: white">Excel</a></li>
							</ul>
							<div class="tab-content">
								<div class="panel panel-primary" style="height: 400px">
									<div class="tab-pane fade in active" id="google"
										style="background-color: white; width: 100%;">
										<form action="CreateProject" method='post'>
											<input type="text" name="pid" placeholder="Project id"
												class="form-control"
												style="width: 19%; display: inline-block" /> <input
												type="text" name="pname" placeholder="Project name"
												class="form-control"
												style="width: 80%; display: inline-block" /> <br> <br>
											<textarea name="pdesc" style="resize: none" rows="5"
												placeholder="Project Description" class="form-control"></textarea>
											<br> <input type="text" name="testSheet_url"
												id="testSheet_url" placeholder="Test Sheet url"
												class="form-control"
												style="width: 90%; display: inline-block" /><input
												type="button" class="btn" style="color: black"
												value="Inspect" onclick="fetchSheetDetails('testSheet')" />
											<br>
											<div id="testSheet_name"></div>
											<br> <input type="text" name="stm_url" id="stm_url"
												placeholder="STM url" class="form-control"
												style="width: 90%; display: inline-block" /> <input
												type="button" class="btn" style="color: black"
												value="Inspect" onclick="fetchSheetDetails('stm')" /> <br>
											<div id="stm_name"></div>
											<br> <input type="submit" class="btn btn-primary"
												value="Create Project">
											<button type="button" class="btn btn-default"
												data-dismiss="modal">Cancel</button>

										</form>
									</div>
									<div id="excel" class="tab-pane fade"
										style="background-color: white; width: 100%; display: none">
										<form action="#" method='post'>
											<input type="text" name="pid" placeholder="Project id"
												class="form-control"
												style="width: 19%; display: inline-block" /> <input
												type="text" name="pname" placeholder="Project name"
												class="form-control"
												style="width: 80%; display: inline-block" /> <br> <br>
											<textarea name="pdesc" style="resize: none" rows="5"
												placeholder="Project Description" class="form-control"></textarea>
											<br> <input type="text" name="testSheet_file"
												id="testSheet_file" placeholder="Test Sheet file (.xls)"
												class="form-control"
												style="width: 90%; display: inline-block" /><input
												type="button" class="btn" style="color: black"
												value="Browse" /> <br>
											<div id="testSheet_name"></div>
											<br> <input type="text" name="stm_file" id="stm_file"
												placeholder="STM file (.xls)" class="form-control"
												style="width: 90%; display: inline-block" /> <input
												type="button" class="btn" style="color: black"
												value="Browse" /> <br> <br> <input type="submit"
												class="btn btn-primary" value="Create Project">
											<button type="button" class="btn btn-default"
												data-dismiss="modal">Cancel</button>
										</form>

									</div>
								</div>

							</div>
						</div>
					</div>
					<!--		<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					</div>
			-->
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
						<select class="form-control" placeholder="select project"
							id="selected_project" onchange="getTestSheets()">
							<option selected disabled>Project Name</option>
							<%
								List<String[]> projects = new ArrayList<String[]>(ob.getProjects());
								for (String[] p : projects) {
							%>
							<option value="<%=p[0]%>"><%=p[1]%></option>
							<%
								}
							%>
						</select> <br> <select class="form-control" id="selected_testsheet"
							name="selected_testsheet" onchange="getWorkSheets()">
							<option selected disabled>Test Sheet</option>
						</select><br> <select class="form-control" id="selected_worksheet"
							name="selected_worksheet">
							<option selected disabled>Worksheet Name</option>
						</select> <br> <br> <input type="text" name="q_range"
							class="form-control" placeholder="* Queries Range"
							style="float: right" /><br> <br> <input type="text"
							name="op_range" class="form-control" placeholder="Output Range"
							style="float: right" /><br> <br> Override Date <input
							class="form-control" type="text" placeholder="Start"
							style="width: 15%; display: inline" /> <input type="text"
							class="form-control" placeholder="End"
							style="width: 15%; display: inline" /><br> <br> <input
							type="checkbox" name='p_exec' value="p_exec" style="float: left">
						&nbsp;Parallel Exec <br> <input type="checkbox"
							name='write_once' value="write_once" style="float: left"
							checked='true'> &nbsp;Post write<br> <br> <input
							type="submit" value="Rerun" class="btn btn-info"> <br>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>


	<script src="template_files/modernizr.custom.js"></script>
	<script src="template_files/jquery.easing.1.3.js"></script>

	<script src="template_files/jquery.appear.js"></script>
	<script src="template_files/stellar.js"></script>
	<script src="template_files/classie.js"></script>
	<script src="template_files/animate.js"></script>
	<script src="template_files/custom.js"></script>

</body>
</html>