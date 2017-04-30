<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="template_files/bootstrap.min.css" />
<title>Parakhi - 0.7</title>
</head>
<body>

	<form action="Login" method="post"
		style="position: fixed; width: 300px; margin-left: 25%; margin-top: 20px">
		<img src="res/images/parrot.jpg" alt="Grey parrot" style="width:300px;height:200px;opacity: 0.5;" onmouseover="this.style.opacity='1';" onmouseout="this.style.opacity='0.5';">
		<pre style="width: 300px;background-color: gainsboro;">
  __  
 |__)    
 |  ARAKHI   <i>alpha</i>
</pre>
		<br> <input type="text" placeholder="Username" name="uname"
			class="form-control" style="width: 300px" /> <br> <input
			type="password" placeholder="Password" name="pass"
			class="form-control" style="width: 300px" /> <br> 
			<input type="checkbox" value="remember" />&nbsp;Remember me <br><br>
			<input
			type="submit" value="Sign in" class="btn btn-success" style="float:left;width:49%"/>
			<input
			type="button" value="Register" class="btn btn-info" style="float:right;width:49%"/>
		
	</form>
	
</body>
</html>