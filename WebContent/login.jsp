<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="template_files/bootstrap.min.css"/>
<title>Insert title here</title>
</head>
<body>
	<form action="Login" method="post">
		<table class="table">
			<tr>
				<td>
					<input type="text" placeholder="Username" name="uname" class="form-control"/>
				</td>
			</tr>
			<tr>
				<td>
					<input type="password" placeholder="Password" name="pass" class="form-control"/>
				</td>
			</tr>
			<tr>
				<td>
					<input type="submit" value="Get Me in ->" class="btn btn-danger"/>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>