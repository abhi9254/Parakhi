function setActiveProj(proj_id, proj_nm) {
	var x = new XMLHttpRequest()
	x.open("GET", "index_ajax2.jsp?setProj=1&proj_id=" + proj_id + "&proj_nm="
			+ proj_nm, true)
	x.send(null)
	x.onreadystatechange = function() {
		if (x.readyState == 4) {

		}
	}
}

function openCity(evt, cityName) {
	var i, tabcontent, tablinks;
	tabcontent = document.getElementsByClassName("tabcontent");
	for (i = 0; i < tabcontent.length; i++) {
		tabcontent[i].style.display = "none";
	}
	tablinks = document.getElementsByClassName("tablinks");
	for (i = 0; i < tablinks.length; i++) {
		tablinks[i].className = tablinks[i].className.replace(" active", "");
	}
	document.getElementById(cityName).style.display = "block";
	evt.currentTarget.className += " active";
}

function fetchSheetDetails(url_type) {

	if (document.getElementById(url_type + "_url").value == "")
		document.getElementById(url_type + "_url").placeholder = "Empty url";

	else {
		spreadsheet_url = document.getElementById(url_type + "_url").value;
		document.getElementById(url_type + "_url").value = "";
		document.getElementById(url_type + "_url").placeholder = "Retrieving spreadsheet details..";
		var x = new XMLHttpRequest()
		x.open("GET", "index_ajax2.jsp?title=1&spreadsheet_id="
				+ spreadsheet_url, true)
		x.send(null)
		x.onreadystatechange = function() {
			if (x.readyState == 4) {
				document.getElementById(url_type + "_title_success").value = x.responseText;
				document.getElementById(url_type + "_url_success").value = spreadsheet_url;
				document.getElementById(url_type + "_url").value = "";
				document.getElementById(url_type + "_url").placeholder = x.responseText;
			}
		}
	}
}