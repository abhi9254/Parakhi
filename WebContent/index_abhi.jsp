<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.util.List,org.abhi.parakhi.MySQL_dao"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Parakhi - 0.5</title>
<link rel="stylesheet" href="/Parakhi/style.css" type="text/css">
<link rel="stylesheet" href="/Parakhi/animate.css" type="text/css">
<link rel="stylesheet" href="/Parakhi/css/bootstrap.min.css"
	type="text/css">
<script src="/Parakhi/js/jquery-3.1.1.min.js"></script>
<script src="/Parakhi/js/bootstrap.min.js"></script>

<script>
	function searchCase() {
	    
	    var input, filter, ul, li, a, i;
	    input = document.getElementById('search_box');
	    filter = input.value.toLowerCase();
	    ul = document.getElementById("cases_ul");
	    li = ul.getElementsByTagName('li');

	    // Loop through all list items, and hide those who don't match the search query
	    for (i = 0; i < li.length; i++) {
	        a = li[i].getElementsByTagName("a")[0];
	        if (a.innerHTML.toLowerCase().indexOf(filter) > -1) {
	        	li[i].style.display = "";
	        } else {
	            li[i].style.display = "none";
	        }
	    }
	}

function enterQuery(case_id){
	var x = new XMLHttpRequest()
	x.open("GET", "QueryForm?case_id="+case_id, true)
	x.send(null)
	x.onreadystatechange=function(){
		if(x.readyState == 4 && x.status==200){
			document.getElementById("query_text").value=x.responseText;
			document.getElementById("makeQuery").innerHTML=x.responseText;
		}
	}
}


</script>


<%
	MySQL_dao ob = new MySQL_dao();
%>
</head>

<body onload="">


	<ul class="hor_nav_bar">
		<li class="hor_li"><a class="hor_li inactive" href="index.jsp">Home</a></li>
		<li class="hor_li"><a class="hor_li inactive" href="history.jsp">History</a></li>
		<li class="hor_li"><a class="hor_li inactive" href=""
			data-toggle="modal" data-target="#myModal">Project</a></li>
		<li class="hor_li"><a class="hor_li inactive" href="#">Switch
				project</a>
			<div style="position: absolute; z-index: 1;">
				<%
					List<String[]> projects = ob.getProjects();
					for (int i = 0; i < projects.size(); i++) {
				%>
				<a class="hor_li" href="index_abhi.jsp?proj_id=<%=projects.get(i)[0]%>"><%=projects.get(i)[1]%></a>
				<%
					}
				%>
			</div></li>
		<li class="hor_li"><a class="hor_li inactive" target="_blank"
			href="https://docs.google.com/spreadsheets/d/16Fy4uF1MVpAkoW-ads6XabQnuOK2HJQ63mn7FUnNjkE">Sheets</a></li>
		<li class="hor_li"><a class="hor_li inactive" href=""
			data-toggle="modal" data-target="#myModal2">Rerun Sheet</a></li>
		<li class="hor_li"><a class="hor_li inactive"
			href="cross_section.jsp">Cross Section</a></li>
		<li class="hor_li" style="float: right"><a
			class="hor_li inactive" href="settings.jsp">Settings</a></li>
		<li class="hor_li" style="float: right"><a
			class="hor_li inactive" href="">Login</a></li>
	</ul>

	<ul class="ver_nav_bar" id="cases_ul">
		<br>
		<input type="text" id="search_box" onkeyup="searchCase()"
			placeholder="Search.." style="width: 100%">
		<br>
		<br>

		<%
			List<String[]> cases;
			int proj_id;
			if (request.getParameter("proj_id") == null) {
				proj_id = 0;
			} else {
				proj_id=Integer.parseInt(request.getParameter("proj_id"));
				
			}cases = ob.getCases(proj_id);
			for (int i = 0; i < cases.size(); i++) {
		%>
		<li class="ver_li" title="<%=cases.get(i)[2]%>"><a
			class="ver_li inactive" onclick="enterQuery(<%=cases.get(i)[0]%>)"
			href="#"><%=cases.get(i)[1]%></a></li>
		<%
			}
		%>
	</ul>


	<div class="modal fade" id="myModal" role="dialog">
		<div class="modal-dialog modal-lg">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">New Project</h4>
				</div>
				<div class="modal-body">
					<form action='' method='post'>
						<div style="display: inline-block">
							Project name <input type="text" name="pname" /><br> <br>
							Project Desc
							<textarea name="pdesc" style="resize: none"></textarea>
							<br> <br>
						</div>
						<div style="display: inline-block">
							Database <select>
								<option>db_gold</option>
								<option>db_stage</option>
							</select><br> <br> Tables <select multiple>
								<option>gold_product_sku</option>
								<option>gold_sales_dly</option>
							</select> <input type='button' value='Add' />
						</div>
						<br> <br> <input type="submit" value="Create Project">
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>

		</div>
	</div>

	<div class="modal fade" id="myModal2" role="dialog">
		<div class="modal-dialog modal-lg">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Rerun Sheet</h4>
				</div>
				<div class="modal-body">
					<form action='rerunSheet.jsp' method='post'>
						<div style="display: inline-block">
							Project name <input type="text" name="pname" style="float: right" /><br>
							<br> Sheet Id <input type="text" name="s_id"
								style="float: right" /><br> <br> Queries Range <input
								type="text" name="q_range" value="Second!F12:F13"
								style="float: right" /><br> <br> Output Range <input
								type="text" name="op_range" value="Second!I12:I13"
								style="float: right" /><br> <br> <input
								type="checkbox" name='p_exec' value="p_exec" style="float: left">
							Parallel Exec <br>
						</div>
						<br> <br> <input type="submit" value="Rerun"> <br>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>




	<form action="Query" method="post" id="form1">
		<div style="float: left; clear: left">
			<textarea name="query_text" id="query_text"></textarea>
			<input class="fire-button" type="submit" value="Fire" /><br><br>
			<div id="makeQuery" style="font-size:large;border:1px solid black;height:200px;" oninput="makeQuery(100)"></div>

		</div>
	</form>
</body>
</html>