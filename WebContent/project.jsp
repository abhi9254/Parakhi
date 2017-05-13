<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.google.api.client.auth.oauth2.Credential"%>
<%@ page
	import="org.abhi.parakhi.MySQL_dao,org.abhi.parakhi.CoordinatorAPI,java.util.ArrayList,java.util.List"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Parakhi - 0.7</title>

<link rel="stylesheet" href="/Parakhi/css/bootstrap.min.css"
	type="text/css">
<link href="template_files/style.css" rel="stylesheet" />
<link rel="stylesheet" href="/Parakhi/css/style.css" type="text/css" />


<script src="/Parakhi/js/jquery-3.1.1.min.js"></script>
<script src="/Parakhi/js/bootstrap.min.js"></script>
<script src="/Parakhi/js/parakhi.js"></script>

<script>
function showProjectDetails(proj_id){
	
	var w = new XMLHttpRequest()
	w.open("GET", "index_ajax2.jsp?about=1&proj_id=" + proj_id,
			true)
	w.send(null)
	w.onreadystatechange = function() {
		if (w.readyState == 4) {
			document.getElementById("about").innerHTML = w.responseText;
		}
	}
	
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


	<ul class="ver_nav_bar"
		style="overflow-y: auto; list-style-type: none; padding: 0; height: calc(100vh - 51px)"
		id="projects_ul">
		<input type="text" id="myInput" onkeyup="myFunction()"
			placeholder="Search...">
		<%
			MySQL_dao ob = new MySQL_dao();
			List<String[]> projs = new ArrayList<String[]>(ob.getProjects());
			for (int i = 0; i < projs.size(); i++) {
		%>
		<li class="ver_li" title="<%=projs.get(i)[2]%>"><a
			class="ver_li inactive" href="#"
			onclick="showProjectDetails(<%=projs.get(i)[0]%>)"
			style="font-size: large"><%=projs.get(i)[1]%></a></li>

		<%
			}
		%>
	</ul>

	<div class="panel-group" id="accordion"
		style="margin-left: 15.5%; margin-top: 10px">

		<div class="panel panel-default">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a data-toggle="collapse" data-parent="#accordion"
						href="#collapse1" style="display: block; text-decoration: none">About</a>
				</h4>
			</div>
			<div id="collapse1" class="panel-collapse collapse in">
				<div id="about"
					style="width: 40%; padding: 10px; margin: 0px; display: inline-block; float: top">
					<%
						boolean activeSession = false;
						int pid = 0;
						if (request.getSession().getAttribute("proj_id") != null) {
							pid = Integer.parseInt(request.getSession().getAttribute("proj_id").toString());
							activeSession = true;

						}
						if (activeSession && pid != 0) {
							String[] p_dtls = ob.getProjDtls(pid);
					%>
					<label>Project Id : </label>
					<%=pid%><br> <label>Project Name : </label>
					<%=p_dtls[1]%><br> <label>Project Desc : </label>
					<%=p_dtls[2]%>
					<%
						} else {
					%>Select a project..
					<%
						}
					%>
				</div>
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
					style="width: 40%; padding: 10px; margin: 0px; display: inline-block; float: top">
					<%
						if (activeSession && pid != 0) {
							List<String[]> ss_list = new ArrayList<String[]>(ob.getSTMsheets(pid));

							for (String[] ss : ss_list) {
					%>
					<%=ss[1]%>
					<a href='' style='float: right;'>Remove</a> <a href=''
						style='float: right; margin-right: 10px'>Refresh</a> <a
						target='_blank' href='<%=ss[2]%>'
						style='float: right; margin-right: 10px'>View</a>
					<%
						}
						} else {
					%>Select a project..
					<%
						}
					%>
				</div>
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
					style="width: 40%; padding: 10px; margin: 0px; display: inline-block; float: top">

					<%
						if (activeSession && pid != 0) {
							List<String[]> ts_list = new ArrayList<String[]>(ob.getTestsheets(pid));

							for (String[] ts : ts_list) {
					%>
					<%=ts[1]%>
					<a href='' style='float: right;'>Remove</a> <a href=''
						style='float: right; margin-right: 10px'>Refresh</a> <a
						target='_blank' href='<%=ts[2]%>'
						style='float: right; margin-right: 10px'>View</a>

					<%
						}
						} else {
					%>Select a project..
					<%
						}
					%>
				</div>
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
					style="width: 40%; padding: 10px; margin: 0px; display: inline-block; float: top">


					<%
						if (activeSession && pid != 0) {
							List<String> src_db_list = new ArrayList<String>(ob.getProjDbNames(pid));

							for (String src_db : src_db_list) {
					%>
					<b>Source: <%=src_db%></b><br>
					<%
						String[] tables = ob.getDbTblNames(pid, src_db);

								for (int i = 0; i < tables.length; i++) {
					%>
					Table:
					<%=tables[i]%>, Frequency: daily <a href='' style='float: right'>Remove</a>
					<a href='' style='float: right; margin-right: 10px'>Refresh</a> <br>
					<%
						}
							}
						} else {
					%>Select a project..
					<%
						}
					%>



				</div>
				<a href="" style="float: right; margin-right: 50px">Add</a><br>
			</div>
		</div>



		<div class="panel panel-default">
			<div class="panel-heading">
				<h4 class="panel-title">
					<a data-toggle="collapse" data-parent="#accordion"
						href="#collapse5" style="display: block; text-decoration: none">Coordinator
						Feed</a>
				</h4>
			</div>
			<div id="collapse5" class="panel-collapse collapse">
				<div id="flows_list"
					style="width: 70%; padding: 10px; margin: 0px; display: inline-block; float: top">
					<%
						CoordinatorAPI ob2 = new CoordinatorAPI();
						String batch_id = ob2.getLastSuccessfulRunBatchId("DATA_INGESTION_DEFAULT_AREA_LAND_DETAILS_L1_FLOW_ID",
								"DATA_INGESTION_DEFAULT_AREA_LAND_DETAILS_L1_JOB_ID");
					%>
					<label>DATA_INGESTION_DEFAULT_AREA_LAND_DETAILS_L1_FLOW_ID : </label>
					DATA_INGESTION_DEFAULT_AREA_LAND_DETAILS_L1_JOB_ID <label>Last
						Successful batch : </label>
					<%=batch_id%>
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
				<form action="#" method='post'>
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
						<input type="text" name="testSheet_url" id="testSheet_url"
							placeholder="Test Sheet url" class="form-control"
							style="width: 80%; display: inline-block" />&nbsp; <input
							type="button" class="btn" style="color: black" value="Inspect" />
						<br>
						<div id="testSheet_name"></div>
						<br> <input type="text" name="stm_url" id="stm_url"
							placeholder="STM url" class="form-control"
							style="width: 80%; display: inline-block" />&nbsp; <input
							type="button" class="btn" style="color: black" value="Inspect" />
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
					<a title="<%=p[2]%>" href="" style="color: grey"
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
</body>

</html>