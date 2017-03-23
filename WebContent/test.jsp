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

.switch {
	position: relative;
	display: inline-block;
	width: 50px;
	height: 25px;
}

/* Hide default HTML checkbox */
.switch input {
	display: none;
}

/* The slider */
.slider {
	position: absolute;
	cursor: pointer;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: #ccc;
	-webkit-transition: .4s;
	transition: .4s;
	bottom: 0;
}

.slider:before {
	position: absolute;
	content: "";
	height: 22px;
	width: 22px;
	left: 2px;
	bottom: 2px;
	background-color: white;
	-webkit-transition: .4s;
	transition: .4s;
}

input:checked+.slider {
	background-color: #2196F3;
}

input:focus+.slider {
	box-shadow: 0 0 1px #2196F3;
}

input:checked+.slider:before {
	-webkit-transform: translateX(24px);
	-ms-transform: translateX(24px);
	transform: translateX(24px);
}

/* Rounded sliders */
.slider.round {
	border-radius: 34px;
}

.slider.round:before {
	border-radius: 50%;
}
</style>
<script src="js/jquery-3.1.1.min.js" type="text/javascript"></script>
<script src="js/bootstrap.min.js" type="text/javascript"></script>
<script src="js/chosen.jquery.min.js" type="text/javascript"></script>
<Script>
	function func() {
		alert('hi');
	}
</Script>
</head>
<body>
	<div class="ver_nav_bar">
		<br> <input type="text" id="myInput" onkeyup="myFunction()"
			style="width: 100%" placeholder="Search.."> <br> <br>



		<ul class="nav nav-tabs">
			<li class="active" style="width: 50%"><a data-toggle="tab"
				href="#global">Global</a></li>
			<li style="width: 50%"><a data-toggle="tab" href="#project">Project</a></li>
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
		<select id="second" data-placeholder="Choose a Country..."
			style="border-color: transparent" class="chosen-select" multiple
			style="width: 350px;" tabindex="4">
			<option value="*">*</option>
			<option value="United States,United Kingdom,Afghanistan">All</option>
			<option value="United States">United States</option>
			<option value="United Kingdom">United Kingdom</option>
			<option value="Afghanistan">Afghanistan</option>
		</select> <br /> <br />
		<button class="btn">Reset</button>
	</div>

	<div
		style="border: 1px solid; width: 400px; height: 100px; margin-left: 15%; padding: 1em;">

	</div>
	<div
		style="width: 400px; height: 50px; margin-left: 15%; padding: 1em;">

		<label class="switch" style="float: right; display: inline"><input
			type="checkbox" onclick="func()">
			<div class="slider round"></div> </label>
		<div style="display: inline; width: 300px; height: 50px;">
			<h5 style='float: right; margin-top: 6px; margin-right: 4px;'>Edit
				Query</h5>
		</div>
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