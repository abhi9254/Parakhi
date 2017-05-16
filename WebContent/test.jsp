<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page
	import="org.abhi.parakhi.CoordinatorAPI,java.util.ArrayList,java.util.List,org.json.*"%>
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
<hr/>
<hr/>
<%
String[] batchDetails = ob.getBatchIdDetails(batch_id);
out.println(batchDetails[0]+batchDetails[1]+batchDetails[2]);

/*
JSONObject obj = new JSONObject(batchDetails);
out.println("Last Successful Run Start Time:"+obj.getString("startTime"));
out.println("<hr>");
out.println("Last Successful Run End Time:"+obj.getString("endTime"));
out.println("Last Successful Flow Instance ID:"+obj.getJSONObject("flowInstance").getInt("id"));
*/

%>
</body>
</html>