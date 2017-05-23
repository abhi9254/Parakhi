<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page
	import="java.sql.DriverManager, java.sql.Connection, java.sql.ResultSet, java.sql.Statement"%>
<%@page
	import="java.util.List,java.util.ArrayList,java.util.Set,java.util.HashSet"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
		String driverName = "org.apache.hive.jdbc.HiveDriver";
		List<String[]> hiveColumns = new ArrayList<String[]>();
		try {
			Class.forName(driverName);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		try {
			//	Connection con = DriverManager.getConnection("jdbc:hive2://10.200.99.242:10000/default", "hive", "");
			Connection con = DriverManager.getConnection("jdbc:hive2://localhost:10000/default", "hive", "");

			Statement stmt = (Statement) con.createStatement();
			//	String query ="analyze table raw_consumer_price_index_details compute statistics for columns sku_id,dept_nm,gma_nm,age_grp,gender,price";
			//	stmt.executeQuery(query);		

			//	String query1 ="use db_gold";
			//	stmt.execute(query1);

			//	String query2 ="analyze table gold_product_sku compute statistics for columns price";
			//	stmt.execute(query2);

			String query = "describe formatted db_gold.gold_product_sku dept_nm";

			ResultSet hiveCols = stmt.executeQuery(query);
			while (hiveCols.next()) {

				String[] s = new String[11];

				s[0] = hiveCols.getString(1);
				s[1] = hiveCols.getString(2);
				s[2] = hiveCols.getString(3);
				s[3] = hiveCols.getString(4);
				s[4] = hiveCols.getString(5);
				s[5] = hiveCols.getString(6);
				s[6] = hiveCols.getString(7);
				s[7] = hiveCols.getString(8);
				s[8] = hiveCols.getString(9);
				s[9] = hiveCols.getString(10);
				s[10] = hiveCols.getString(11);
				hiveColumns.add(s);

			}
			hiveCols.close();
			con.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		out.println("<table border='1'><thead><tr>");
		out.println("<th>" + hiveColumns.get(0)[0] + "</th>");
		out.println("<th>" + hiveColumns.get(0)[1] + "</th>");
		out.println("<th>" + hiveColumns.get(0)[2] + "</th>");
		out.println("<th>" + hiveColumns.get(0)[3] + "</th>");
		out.println("<th>" + hiveColumns.get(0)[4] + "</th>");
		out.println("<th>" + hiveColumns.get(0)[5] + "</th>");
		out.println("<th>" + hiveColumns.get(0)[6] + "</th>");
		out.println("<th>" + hiveColumns.get(0)[7] + "</th>");
		out.println("<th>" + hiveColumns.get(0)[8] + "</th>");
		out.println("<th>" + hiveColumns.get(0)[9] + "</th>");
		out.println("<th>" + hiveColumns.get(0)[10] + "</th>");
		out.println("</tr></thead><tbody><tr>");
		out.println("<td>" + hiveColumns.get(2)[0] + "</th>");
		out.println("<td>" + hiveColumns.get(2)[1] + "</th>");
		out.println("<td>" + hiveColumns.get(2)[2] + "</th>");
		out.println("<td>" + hiveColumns.get(2)[3] + "</th>");
		out.println("<td>" + hiveColumns.get(2)[4] + "</th>");
		out.println("<td>" + hiveColumns.get(2)[5] + "</th>");
		out.println("<td>" + hiveColumns.get(2)[6] + "</th>");
		out.println("<td>" + hiveColumns.get(2)[7] + "</th>");
		out.println("<td>" + hiveColumns.get(2)[8] + "</th>");
		out.println("<td>" + hiveColumns.get(2)[9] + "</th>");
		out.println("<td>" + hiveColumns.get(2)[10] + "</th>");
		out.println("</tr></tbody></table>");
	%>
</body>
</html>