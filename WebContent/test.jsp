<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test</title>
<link rel="stylesheet" href="css/bootstrap.min.css" type="text/css">
<link rel="stylesheet" href="css/chosen.css" type="text/css">
<style>
body {
	
}

.ver_nav_bar {
	margin-top: 0px;
	padding: 0;
	width: 15%;
	background-color: #f1f1f1;
	position: fixed;
	height: 100%;
	overflow: auto;
}
.chosen-container-multi .chosen-choices {
overflow: initial;
border: 0px;
}

</style>
<script src="js/jquery-3.1.1.min.js" type="text/javascript"></script>
<script src="js/bootstrap.min.js" type="text/javascript"></script>
<script src="js/chosen.jquery.min.js" type="text/javascript"></script>

</head>
<body>
	<div class="ver_nav_bar">
		<br> <input type="text" id="myInput" onkeyup="myFunction()"
			style="width: 100%" placeholder="Search.."> <br> <br>

		

			<ul class="nav nav-tabs">
			<li class="active" style="width:50%"><a data-toggle="tab" href="#global">Global</a></li>
			<li style="width:50%"><a data-toggle="tab" href="#project">Project</a></li>
		</ul>

		<div class="tab-content">
			<div id="global" class="tab-pane fade in active">
				<ul id="cases_ul">
					<li class="ver_li" title="dummy"><a class="ver_li inactive"
						href="#" onclick="enterQuery('dummy','dummy')"
						style="font-size: large">option 1</a></li>
				</ul>
			</div>
			<div id="project" class="tab-pane fade">
				<ul id="cases_ul2">
					<li class="ver_li" title="dummy"><a class="ver_li inactive"
						href="#" onclick="enterQuery('dummy','dummy')"
						style="font-size: large">option 2</a></li>
				</ul>
			</div>

		</div>
		
		 
	</div>

	<div style="margin-left: 15%; padding: 1em;">
		<select id="second" data-placeholder="Choose a Country..." style="border-color: transparent"
			class="chosen-select" multiple style="width: 350px;" tabindex="4">
			<option value="*">*</option>
			<option value="United States,United Kingdom,Afghanistan">All</option>
			<option value="United States">United States</option>
			<option value="United Kingdom">United Kingdom</option>
			<option value="Afghanistan">Afghanistan</option>
		</select> <br /> <br />
		<button class="btn">Reset</button>
	</div>
</body>
<script>
	$(document).ready(function() {
		$(".chosen-select").chosen();
		$('button').click(function() {
			$(".chosen-select").val('').trigger("chosen:updated");
		});
	});
</script>
</html>