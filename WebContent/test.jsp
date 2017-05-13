<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page
	import="org.abhi.parakhi.CoordinatorAPI,java.util.ArrayList,java.util.List"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
CoordinatorAPI ob = new CoordinatorAPI();
String batch_id = ob.getLastSuccessfulRunBatchId("DATA_INGESTION_DEFAULT_AREA_LAND_DETAILS_L1_FLOW_ID", "DATA_INGESTION_DEFAULT_AREA_LAND_DETAILS_L1_JOB_ID");
out.println(batch_id);
%>
</body>
</html>