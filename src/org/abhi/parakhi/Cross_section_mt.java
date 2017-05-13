package org.abhi.parakhi;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.hive.jdbc.HiveStatement;

public class Cross_section_mt extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public List<String[]> samplePrepare(List<String[]> queries, String[] cols, int i, String db, String tbl) {

		System.out.println("Function samplePrepare entered");
		List<String[]> queries_ = new ArrayList<String[]>();
		System.out.println("No of columns for sampling: " + cols.length);
		System.out.println("No of unique queries already: " + queries.size());

		String driverName = "org.apache.hive.jdbc.HiveDriver";

		try {
			Class.forName(driverName);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}

		StringBuilder query = new StringBuilder("select distinct " + cols[i] + " from " + db + "." + tbl);

		if (i == 0) {
			try {
			//	Connection con = DriverManager.getConnection("jdbc:hive2://localhost:10000/default", "hive", "");
				Connection con = DriverManager.getConnection("jdbc:hive2://10.200.99.242:10000/default", "hive", "");
				HiveStatement stmt = (HiveStatement) con.createStatement();
				System.out.println(query);
				System.out.println("Entered column index i==0 if block");
				ResultSet res = stmt.executeQuery(query.toString());
				while (res.next()) {
					String[] op = new String[1];
					op[0] = (res.getString(1));
					System.out.println("Added " + res.getString(1) + " to op string");
					queries_.add(op);
				}
				con.close();
			} catch (Exception e) {
				e.printStackTrace();
			}

		} else {

			System.out.println("In column index i==0 else block");
			try {

				ExecutorService executor = Executors.newFixedThreadPool(2);
				for (String[] s : queries) {
					for (int j = 0; j < i; j++) {
						if (j == 0) {
							System.out.println("In query append j==0 if block");
							query.append(" where " + cols[0] + "='" + s[0] + "'");
						} else {
							System.out.println("In query append j==0 else block");
							query.append(" and " + cols[j] + "='" + s[j] + "'");
						}

					}
					Runnable worker = new MyRunnable(query.toString(), queries_, s, i);
					executor.execute(worker);

					// Resetting query
					query = new StringBuilder("select distinct " + cols[i] + " from " + db + "." + tbl);

				}
				executor.shutdown();
				// Wait until all threads are finish
				while (!executor.isTerminated()) {

				}
				System.out.println("\nFinished all threads");

			} catch (Exception ex) {
				ex.printStackTrace();
			}

		}
		return queries_;

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String db = request.getParameter("database");
		String tbl = request.getParameter("table");
		String[] cols = request.getParameterValues("cols");

		List<String[]> queries = new ArrayList<String[]>();
		for (int i = 0; i < cols.length; i++) {

			queries = samplePrepare(queries, cols, i, db, tbl);

			for (String[] s : queries) {
				for (int m = 0; m < s.length; m++) {
					System.out.print(s[m] + ",");
				}
				System.out.println();
			}
		
			System.out.println(
					"Queries preparation tree: Step " + i + " complete. Total no of queries: " + queries.size() + "\n");
		}
			int queries_size = queries.size();
			StringBuilder query_text = new StringBuilder("");
			for (int j = 0; j < queries_size; j++) {
				String[] s = queries.get(j);

				if (j == queries_size - 1) {
					query_text.append("Select * from " + db + "." + tbl + " where " + cols[0] + "='" + s[0] + "'");
					for (int k = 1; k < s.length; k++)
						query_text.append(" and " + cols[k] + "='" + s[k] + "'");
					query_text.append(" limit 1");
				} else {
					query_text.append("Select * from " + db + "." + tbl + " where " + cols[0] + "='" + s[0] + "'");
					for (int k = 1; k < s.length; k++)
						query_text.append(" and " + cols[k] + "='" + s[k] + "'");
					query_text.append(" limit 1 \nUNION ALL \n");
				}
			}
			System.out.println(query_text);
			 request.setAttribute("query_text", query_text);
			 
			 try {
					Class.forName("org.apache.hive.jdbc.HiveDriver");
				} catch (ClassNotFoundException e) {
					e.printStackTrace();
				}
				try {
					Connection con = DriverManager.getConnection("jdbc:hive2://localhost:10000/default", "hive", "");
					HiveStatement stmt = (HiveStatement) con.createStatement();
					
					ResultSet res = stmt.executeQuery(query_text.toString());
					String log=stmt.getLog().toString();
								
					request.setAttribute("result", res);
					request.setAttribute("user_query", query_text.toString());
					request.setAttribute("query_log", log);
					RequestDispatcher rd = getServletContext().getRequestDispatcher("/result.jsp");
					rd.forward(request, response);
					stmt.close();
					res.close();
					con.close();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			 
			 
	}
}

class MyRunnable implements Runnable {
	private final String query;
	private List<String[]> queries_;
	private String[] s;
	private int i;

	MyRunnable(String query, List<String[]> queries_, String[] s, int i) {
		this.query = query;
		this.queries_ = queries_;
		this.s = s;
		this.i = i;
	}

	@Override
	public void run() {
		System.out.println("New thread \n" + query);

		try {
			Connection con = DriverManager.getConnection("jdbc:hive2://localhost:10000/default", "hive", "");
			HiveStatement stmt = (HiveStatement) con.createStatement();

			ResultSet res = stmt.executeQuery(query);
			while (res.next()) {
				String[] op = new String[i + 1];
				int l = s.length;
				for (int k = 0; k < l; k++) {
					op[k] = s[k];
				}
				op[l] = (res.getString(1));
				System.out.println("Added " + res.getString(1) + " to op string");
				queries_.add(op);

			}
			con.close();
		} catch (Exception ex) {
			ex.printStackTrace();
		}

	}
}