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
import java.sql.SQLException;

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
			// Connection con =
					 //	 DriverManager.getConnection("jdbc:hive2://localhost:10000/default",
					 //	 "hive", "");
			Connection con = DriverManager.getConnection("jdbc:hive2://10.200.99.242:10000/default", "hive", "");
			HiveStatement stmt = (HiveStatement) con.createStatement();
			String query_ = request.getParameter("query_text");

			String query;
			if (query_.toLowerCase().contains("show ") || query_.toLowerCase().contains("describe ") || query_.toLowerCase().contains("create ") || query_.toLowerCase().contains("msck ") || query_.toLowerCase().contains("limit "))
				query = query_;
			else
				query = query_ + " limit 100";

			ResultSet res = stmt.executeQuery(query);
			// String log=stmt.getLog().toString();
			String log = "log disabaed";
			request.setAttribute("result", res);
			request.setAttribute("user_query", query);
			request.setAttribute("query_log", log);
			RequestDispatcher rd = getServletContext().getRequestDispatcher("/result.jsp");
			rd.forward(request, response);
			res.close();
			con.close();

		} catch (Exception ex) {
			String query = request.getParameter("query_text") + " limit 100";
			// String log=stmt.getLog().toString();
			String log = "log disabaed";
			request.setAttribute("user_query", query);
			request.setAttribute("query_log", log);
			request.setAttribute("error_msg", ex.toString());
			RequestDispatcher rd = getServletContext().getRequestDispatcher("/hiveError.jsp");
			rd.forward(request, response);

		}

	}
}
