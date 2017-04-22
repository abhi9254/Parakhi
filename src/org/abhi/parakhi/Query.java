package org.abhi.parakhi;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.ResultSet;
import org.apache.hive.jdbc.HiveStatement;

//@WebServlet("/Query")
public class Query extends HttpServlet {

	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String driverName = "org.apache.hive.jdbc.HiveDriver";

		try {
			Class.forName(driverName);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
		try {
			Connection con = DriverManager.getConnection("jdbc:hive2://localhost:10000/default", "hive", "");
			//	Connection con = DriverManager.getConnection("jdbc:hive2://10.200.99.242:10000/default", "hive", "");
			HiveStatement stmt = (HiveStatement) con.createStatement();
			String query = request.getParameter("query_text");
			ResultSet res = stmt.executeQuery(query);
		//	String log=stmt.getLog().toString();
			String log = "log disabaed"	;		
			request.setAttribute("result", res);
			request.setAttribute("user_query", query);
			request.setAttribute("query_log", log);
			RequestDispatcher rd = getServletContext().getRequestDispatcher("/result.jsp");
			rd.forward(request, response);
			res.close();
			con.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		
	}
}
