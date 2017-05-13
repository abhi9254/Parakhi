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
<link rel="stylesheet" href="css/style.css" type="text/css" />



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
</style>
<script src="js/jquery-3.1.1.min.js" type="text/javascript"></script>
<script src="js/bootstrap.min.js" type="text/javascript"></script>
<script src="js/chosen.jquery.min.js" type="text/javascript"></script>
<script src="js/parakhi.js" type="text/javascript"></script>
<script>
	function refresh_selectors(base_query, base_text, up_base_query,
			up_base_text, up_cols_text) {
		$(document)
				.ready(
						function() {
							$(".chosen-select").chosen();

							$('#tables')
									.on(
											'change',
											function(evt, params) {
												var selected = $(this).val();
												up_base_text = base_text
														.replace(
																' $db.$tableA ',
																" " + selected
																		+ " ");
												document
														.getElementById('query_text').value = up_base_text;
												update_col_selectors(
														base_query, base_text,
														selected, up_base_text,
														up_cols_text);
											});

							$('#columns')
									.on(
											'change',
											function(evt, params) {
												var selected = $(this).val();
												up_cols_text = up_base_text
														.replace(
																/[$]tableA.[$]cols/g,
																selected);
												var mid_text = up_cols_text;
												var total = $('.column').length;
												//	for(i=1; i<total; i++){
												//		if($('#column_'+i).val()!=null)
												//			$('#column_'+i).val(null).trigger('chosen:updated');
												//	}
												for (i = 1; i < total; i++) {
													if ($('#column_' + i).val() != '')
														mid_text = mid_text
																.replace(
																		'$tableA.$col'
																				+ i,
																		$(
																				'#column_'
																						+ i)
																				.val());
												}

												document
														.getElementById('query_text').value = mid_text;
												refresh_selectors(base_query,
														base_text,
														up_base_query,
														up_base_text,
														up_cols_text);
											});
							$('.column')
									.on(
											'change',
											function(evt, params) {

												var selected = $(this).val();
												var select_id = $(this).prop(
														'id').charAt(7);
												var total = $('.column').length;
												var final_text = up_cols_text;
												if (select_id != '') {
													for (i = 1; i < total; i++) {
														if ($('#column_' + i)
																.val() != null)
															final_text = final_text
																	.replace(
																			'$tableA.$col'
																					+ i,
																			$(
																					'#column_'
																							+ i)
																					.val());
													}
													document
															.getElementById('query_text').value = final_text;
													//	refresh_selectors(base_query,base_text,up_base_query,up_base_text,up_cols_text);
												}
											});

						});
	}

	function update_col_selectors(base_query, base_text, selected,
			up_base_text, up_cols_text) {
		up_base_query = base_query.replace("value='' selected", "value=''");
		up_base_query = up_base_query.replace("value='" + selected + "'",
				"value='" + selected + "' selected");

		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax.jsp?col_nms=1" + "&selected=" + selected,
				true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {
				var cols_list = x.responseText;
				var tbl_ptrn = /[$]tableA.[$]col./g;
				up_base_query = up_base_query.replace(/[$]tableA.[$]cols/g,
						cols_list);
				cols_list = cols_list.replace(/columns/g, 'column');
				up_base_query = up_base_query.replace(tbl_ptrn, cols_list);

				var i = 0;
				while (up_base_query.includes("id='column'")) {
					up_base_query = up_base_query.replace("id='column'",
							"id='column_" + (++i) + "'");
				}

				$("#makeQuery").html(up_base_query);

				refresh_selectors(base_query, base_text, up_base_query,
						up_base_text, up_cols_text);
			}
		}
	}
</script>
<script>
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
			if (a.innerHTML.toUpperCase().indexOf(filter) > -1
					|| li[i].title.toUpperCase().indexOf(filter) > -1) {
				//alert(i)
				li[i].style.display = "";
			} else {
				li[i].style.display = "none";
			}

		}

		ul = document.getElementById("proj_cases_ul");
		li = ul.getElementsByTagName('li');

		// Loop through all list items, and hide those who don't match the search query
		for (i = 0; i < li.length; i++) {
			a = li[i].getElementsByTagName("a")[0];
			if (a.innerHTML.toUpperCase().indexOf(filter) > -1
					|| li[i].title.toUpperCase().indexOf(filter) > -1) {
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

		var str = inpQuery.replace(/\[quot\]/g, '\'')
		document.getElementById("setQuery").value = str
		document.getElementById("query_text").value = str

		if (projId != '') {
			var x = new XMLHttpRequest()
			x.open("GET", "index_ajax.jsp?inpQuery=" + str + "&projId="
					+ projId, true)
			x.send(null)
			x.onreadystatechange = function() {
				if (x.readyState == 4) {
					document.getElementById("makeQuery").innerHTML = x.responseText;
					refresh_selectors(x.responseText, str, x.responseText, str,
							'');

				}
			}
		} else
			document.getElementById("makeQuery").innerHTML = str;

		document.getElementById("makeQuery").display = 'inline';
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
				document.getElementById("selected_testsheet").innerHTML = x.responseText;
				document.getElementById("selected_worksheet").innerHTML = "<option selected disabled>Worksheet Name</option>";
			}
		}

	}
	function getSTMsheets() {
		var sel_proj = document.getElementById("selected_project2").value;
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax2.jsp?stmsheets=1&p_id=" + sel_proj, true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {
				document.getElementById("selected_stmsheet").innerHTML = x.responseText;
				document.getElementById("selected_worksheet").innerHTML = "<option selected disabled>Table Name</option>";
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
				document.getElementById("selected_worksheet").innerHTML = x.responseText;
			}
		}
	}

	function getSTMSheetTables() {
		var sel_ss = document.getElementById("selected_stmsheet").value;
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax2.jsp?tbls=1&s_id=" + sel_ss, true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {
				document.getElementById("selected_table").innerHTML = x.responseText;

			}
		}
	}

	function getDatabases() {
		var sel_proj = document.getElementById("selected_project3").value;
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax2.jsp?dbs=1&p_id=" + sel_proj, true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {
				document.getElementById("selected_database").innerHTML = x.responseText;
				document.getElementById("selected_table2").innerHTML = "<option selected disabled>Table</option>";
			}
		}
	}

	function getDatabaseTables() {
		var sel_proj = document.getElementById("selected_project3").value;
		var sel_db = document.getElementById("selected_database").value;
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax2.jsp?tbls=1&p_id=" + sel_proj + "&db="
				+ sel_db, true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {
				document.getElementById("selected_table2").innerHTML = x.responseText;

			}
		}
	}
</script>

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

	<div class="ver_nav_bar">
		<input type="search" id="myInput" oninput="myFunction()"
			placeholder="Search...">

		<ul class="nav nav-tabs">
			<li class="active" style="width: 50%;"><a data-toggle="tab"
				href="#generic">Generic</a></li>
			<li style="width: 50%"><a data-toggle="tab" href="#project">Project</a></li>
		</ul>
		<div class="tab-content">
			<div id="generic" class="tab-pane fade in active">
				<ul
					style="overflow-y: auto; list-style-type: none; padding: 0; height: calc(100vh - 140px)"
					id="cases_ul">
					<%
						int active_proj = 0;
						if (request.getSession().getAttribute("proj_id") != null) {
							active_proj = Integer.parseInt(request.getSession().getAttribute("proj_id").toString());
						}
						MySQL_dao ob = new MySQL_dao();
						List<String[]> cases = new ArrayList<String[]>(ob.getCases(0));

						for (String[] c : cases) {
					%>
					<li class="ver_li" title="<%=c[2]%>"><a
						class="ver_li inactive" href="#"
						onclick="enterQuery('<%=c[3]%>',<%=active_proj%>)"
						style="font-size: large"><%=c[1]%></a></li>

					<%
						}
					%>

				</ul>
			</div>


			<input type="text" hidden="hidden" id="setQuery"> <input
				type="text" hidden="hidden" id="colId">


			<div id="project" class="tab-pane fade">
				<ul
					style="overflow-y: auto; list-style-type: none; padding: 0; height: calc(100vh - 140px)"
					id="proj_cases_ul">
					<%
						List<String[]> proj_cases = new ArrayList<String[]>(ob.getCases(active_proj));

						for (String[] c : proj_cases) {
					%>
					<li class="ver_li" title="<%=c[2]%>"><a
						class="ver_li inactive" href="#"
						onclick="enterQuery('<%=c[3]%>','')" style="font-size: large"><%=c[1]%></a></li>

					<%
						}
					%>
				</ul>
			</div>

		</div>
	</div>

	<div id='clipboard'
		style="display: none; border: 1px solid black; float: right; height: 500px; width: 200px">Clipboard</div>
	<div class="container-fluid">
		<div class="row">
			<div class="col-md-2"></div>
			<div class="col-md-6">
				<form action="Query" method="post"
					style="margin-top: 10px; height: 200px">
					<div class="panel" id="main_panel"
						style="height: 200px; width: 600px; display: inline-block">
						<div id="makeQuery" class="panel panel-body"
							style="font-size: large; height: 200px; width: 600px; display: inline-block; border-width: 1px 1px 1px 4px; border-color: #A9A9A9; border-radius: 0px"></div>

					</div>


					<textarea name="query_text" id="query_text" cols="100" rows="5"
						style="resize: none; font-size: large; font-color: black; border: 1px solid #A9A9A9; border-left: 4px solid #A9A9A9; border-radius: 0px; height: 200px; display: none">select * from db_gold.gold_product_sku</textarea>

					<input class="btn btn-success btn-lg" type="submit"
						style="display: inline-block; vertical-align: top; height: 200px; width: 80px"
						value="Fire" />
				</form>

				<div style="width: 600px; height: 50px; padding: 1em;">

					<label class="switch" style="float: right; display: inline"><input
						type="checkbox" onclick="editQuery()">
						<div class="slider round"></div> </label>
					<div style="display: inline; width: 500px; height: 50px;">
						<h5 style='float: right; margin-top: 6px; margin-right: 4px;'>Edit
							Query</h5>
					</div>
				</div>
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


	<div class="modal fade" id="styledProject" role="dialog">
		<div class="modal-dialog modal-lg">
			<div class="tab">
				<button class="tablinks active" onclick="openCity(event, 'New')">New
					project</button>

				<button class="tablinks" onclick="openCity(event, 'Existing')">Existing
					project</button>

			</div>

			<div id="New" class="tabcontent">
				<h3>New project</h3>
				<br>
				<form action="CreateProject" method='post'>
					<input type="text" name="pid" placeholder="Project id"
						class="form-control" style="width: 18.5%; display: inline-block" />&nbsp;
					<input type="text" name="pname" placeholder="Project name"
						class="form-control" style="width: 80%; display: inline-block" />
					<br> <br>
					<textarea name="pdesc" style="resize: none" rows="1"
						placeholder="Project Description" class="form-control"></textarea>
					<br>
					<h5>Project files</h5>
					<input class="radio-inline" type="radio" name="filesType">&nbsp;Excel
					<input class="radio-inline" type="radio" name="filesType" checked>&nbsp;Google

					Sheet <br> <br>

					<div id="google_selector">
						<input type="text" id="testSheet_url" placeholder="Test Sheet url"
							class="form-control" style="width: 80%; display: inline-block" />&nbsp;
						<input type="button" class="btn" style="color: black"
							value="Inspect" onclick="fetchSheetDetails('testSheet')" /> <input
							type="text" name="testSheet_url" id="testSheet_url_success"
							hidden="hidden" /> <input type="text" name="testSheet_title"
							id="testSheet_title_success" hidden="hidden" /> <br>
						<div id="testSheet_name"></div>
						<br> <input type="text" id="stm_url" placeholder="STM url"
							class="form-control" style="width: 80%; display: inline-block" />&nbsp;
						<input type="button" class="btn" style="color: black"
							value="Inspect" onclick="fetchSheetDetails('stm')" /> <input
							type="text" name="stm_url" id="stm_url_success" hidden="hidden" />
						<input type="text" name="stm_title" id="stm_title_success"
							hidden="hidden" />
					</div>


					<!-- 		<div id="excel_selector">
					<input type="text" name="testSheet_file"
						id="testSheet_file" placeholder="Test Sheet file (.xls)"
						class="form-control" style="width: 80%; display: inline-block" />&nbsp;
					<input type="button" class="btn" style="color: black"
						value="Browse" /> <br>
					<div id="testSheet_name"></div>
					<br> <input type="text" name="stm_file" id="stm_file"
						placeholder="STM file (.xls)" class="form-control"
						style="width: 80%; display: inline-block" />&nbsp; <input
						type="button" class="btn" style="color: black" value="Browse" />
						</div>
			 -->
					<br> <br> <br> <input type="submit"
						class="btn btn-primary" value="Create Project">
					<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
				</form>

			</div>


			<div id="Existing" class="tabcontent"
				style="display: none; position: relative;">

				<h3>Existing projects</h3>
				<br>

				<%
					//	List<String[]> projs = new ArrayList<String[]>(ob.getProjects());

					for (String[] p : projs) {
				%>



				<h4>
					<a title="<%=p[2]%>" href="index.jsp" style="color: grey"
						onclick="setActiveProj('<%=p[0]%>','<%=p[1]%>')"><%=p[1]%></a>
				</h4>
				<%
					}
				%>
				<button type="button" class="btn btn-default" data-dismiss="modal"
					style="position: absolute; bottom: 20px">Cancel</button>
			</div>
		</div>
	</div>


	<div class="modal fade" id="verifyddl" role="dialog">
		<div class="modal-dialog modal-lg">
			<div
				style="background-color: white; width: 100%; height: 500px display:table">

				<form action='verifyddl.jsp' method='post' style="padding: 20px;">
					<div style="width: 400px; display: table-cell">
						<h4>STM Definition</h4>
						<select class="form-control" placeholder="select project"
							id="selected_project2" onchange="getSTMsheets()">
							<option selected disabled>Project Name</option>
							<%
								List<String[]> projects = new ArrayList<String[]>(ob.getProjects());
								for (String[] p : projects) {
							%>
							<option value="<%=p[0]%>"><%=p[1]%></option>
							<%
								}
							%>
						</select> <br> <select class="form-control" id="selected_stmsheet"
							name="selected_stmsheet" onchange="getSTMSheetTables()">
							<option selected disabled>Stm Sheet</option>
						</select><br> <select class="form-control" id="selected_table"
							name="stm_tbl">
							<option selected disabled>Table Name</option>
						</select> <br>
					</div>
					<div
						style="width: 500px; padding-left: 80px; padding-right: 20px; display: table-cell">
						<h4>Hive table</h4>
						<select class="form-control" placeholder="select project"
							id="selected_project3" onchange="getDatabases()">
							<option selected disabled>Project Name</option>
							<%
								for (String[] p : projects) {
							%>
							<option value="<%=p[0]%>"><%=p[1]%></option>
							<%
								}
							%>
						</select> <br> <select class="form-control" id="selected_database"
							name="selected_database" onchange="getDatabaseTables()">
							<option selected disabled>Database</option>
						</select><br> <select class="form-control" id="selected_table2"
							name="hive_tbl">
							<option selected disabled>Table</option>
						</select> <br>
					</div>
					<br> <input type="checkbox" checked disabled value="colOrder" />Check
					columns order<br> <br> <input type="submit"
						value="Compare" class="btn btn-info">
					<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
					<br>
				</form>
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
							style="width: 20%; display: inline" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Output
						Range <select class="form-control"
							style="width: 100px; display: inline"><option>auto</option>
							<option disabled>custom</select> &nbsp;<input type="text" disabled
							name="op_range" class="form-control" placeholder="Output Range"
							style="display: inline; width: 20%" /><br> <br> <input
							type="checkbox" disabled style="vertical-align: sub;">
						Override Column(s)&nbsp; <input type="text" class="form-control"
							list="cols" name="overridden_cols" placeholder="column_name"
							style="width: 15%; display: inline" />&nbsp;
						<datalist id="cols">
						<option>batch_id</option>
						<option>load_ts</option>
						<option>event_date</option>
						<option>trans_date</option>
						</datalist>

						<input class="form-control" type="text" placeholder="value"
							name="overridden_values" style="width: 25%; display: inline" />&nbsp;&nbsp;&nbsp;&nbsp;
						<h3 style="display: inline">
							<a href="#"
								style="text-decoration: none; vertical-align: middle;">+</a>
						</h3>
						<br> <br> <input class="checkbox-inline" type="checkbox"
							name='p_exec' disabled style="vertical-align: sub;"
							value="p_exec"> &nbsp;Parallel Exec <input
							class="checkbox-inline" type="checkbox" name='write_once'
							style="vertical-align: sub;" value="write_once" checked='true'>
						&nbsp;Post write<br> <br> <input type="submit"
							value="Rerun" class="btn btn-info"> <br>
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