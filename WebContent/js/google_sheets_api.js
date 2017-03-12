// Your Client ID can be retrieved from your project in the Google
// Developer Console, https://console.developers.google.com
var CLIENT_ID = '516645433666-ltekci2vg1n9e52og7kk5vjv2hp0450f.apps.googleusercontent.com';
var SCOPES = [ "https://www.googleapis.com/auth/spreadsheets" ];

/**
 * Check if current user has authorized this application.
 */
function checkAuth() {
	gapi.auth.authorize({
		client_id : CLIENT_ID,
		scope : SCOPES.join(' '),
		immediate : true
	}, handleAuthResult);
}

/**
 * Handle response from authorization server.
 * 
 * @param {Object}
 *            authResult Authorization result.
 */
function handleAuthResult(authResult) {
	var authorizeDiv = document.getElementById('authorize-div');

	if (authResult && !authResult.error) {
		// Hide auth UI, then load client library.
		authorizeDiv.style.display = 'none';
		loadSheetsApi();

	} else {
		// Show auth UI, allowing the user to initiate authorization by
		// clicking authorize button.
		authorizeDiv.style.display = 'inline';
	}
}

/**
 * Initiate auth flow in response to user clicking authorize button.
 * 
 * @param {Event}
 *            event Button click event.
 */
function handleAuthClick(event) {
	gapi.auth.authorize({
		client_id : CLIENT_ID,
		scope : SCOPES,
		immediate : false
	}, handleAuthResult);
	return false;
}

/**
 * Load Sheets API client library.
 */
function loadSheetsApi() {
	var discoveryUrl = 'https://sheets.googleapis.com/$discovery/rest?version=v4';
	gapi.client.load(discoveryUrl);
}

/**
 * Print the names and majors of students in a sample spreadsheet:
 * https://docs.google.com/spreadsheets/d/1BxiMVs0XRA5nFMdKvBdBZjgmUUqptlbs74OgvE2upms/edit
 */
function listMajors() {
	window.alert("lm");
	gapi.client.sheets.spreadsheets.values.get({
		spreadsheetId : '16Fy4uF1MVpAkoW-ads6XabQnuOK2HJQ63mn7FUnNjkE',
		range : 'Second!F9:F11',
		majorDimension : 'COLUMNS',
	}).then(function(response) {
		var range = response.result;
		if (range.values.length > 0) {
			window.alert('Name, Major:');
			for (i = 0; i < range.values.length; i++) {
				var row = range.values[i];
				// Print columns A and E, which correspond to indices 0 and 4.
				window.alert(row[0]);
			}
		} else {
			window.alert('No data found.');
		}
	}, function(response) {
		window.alert('Error: ' + response.result.error.message);
	});
}

/**
 * Append a pre element to the body containing the given message as its text
 * node.
 * 
 * @param {string}
 *            message Text to be placed in pre element.
 */
function appendPre(message) {
	var pre = document.getElementById('output');
	var textContent = document.createTextNode(message + '\n');
	pre.appendChild(textContent);
}


function writeRecord(query, str, pos) {
	alert("write records");
	gapi.client.sheets.spreadsheets.values.update({
		spreadsheetId : '16Fy4uF1MVpAkoW-ads6XabQnuOK2HJQ63mn7FUnNjkE',
		range : pos,
		valueInputOption : 'RAW',
		majorDimension : 'COLUMNS',
		values : [ [ query ], [ str ] ]
	}).then(function(response) {
		var updatedRange = response.result;
		if (updatedRange.updatedCells > 0) {
			document.getElementById('output').innerHTML= updatedRange.updatedCells +' cells updated';
		} else {
			document.getElementById('output').innerHTML= 'No data updated';
		}
	},

	function(response) {
		document.getElementById('output').innerHTML= 'Error: ' + response.result.error.message;
		document.getElementById('push-div').style.display = 'inline';
	})
	document.getElementById('output').style.display = 'inline';
}

function pushToSheet() {
	alert("push to sheet from js function");
	var query = document.getElementById('query').innerHTML;
	var row_c = document.getElementById('res_tbl').rows.length;
	var pos = 'Second!F16:G'

	var i = 0, j = 0;
	var str = "";

	for (i = 0; i < row_c; i++) {
		str = str + "\n";

		var cell_c = document.getElementById("res_tbl").rows[i].cells.length;

		for (j = 0; j < cell_c-1; j++) {

			var x = document.getElementById("res_tbl").rows[i].cells.item(j).innerHTML;

			str = str + x + "\t";
			
		}

	}
	// window.alert(query+"\n\n"+str);
	writeRecord(query, str, pos);
	document.getElementById('push-div').style.display = 'none';
}