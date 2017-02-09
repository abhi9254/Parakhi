package org.abhi.parakhi;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.hive.jdbc.HiveStatement;

public class Cross_section extends HttpServlet {
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
		try {
			Connection con = DriverManager.getConnection("jdbc:hive2://localhost:10000/default", "hive", "");
			HiveStatement stmt = (HiveStatement) con.createStatement();

			StringBuilder query = new StringBuilder("select distinct " + cols[i] + " from " + db + "." + tbl);

			if (i != 0) {
				System.out.println("In i!=0 if block");
				for (String[] s : queries) {
					for (int j = 0; j < i; j++) {
						if (j == 0) {
							System.out.println("In j==0 if block");
							query.append(" where " + cols[0] + "='" + s[0] + "'");
						} else {
							System.out.println("In j==0 else block");
							query.append(" and " + cols[j] + "='" + s[j] + "'");
						}

					}
					System.out.println("\n" + query.toString());
					ResultSet res = stmt.executeQuery(query.toString());

					// Resetting query
					query = new StringBuilder("select distinct " + cols[i] + " from " + db + "." + tbl);

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
					res.close();// System.out.println("Removed "+s[0]+" from
								// output");
				}
			}

			if (i == 0) {
				System.out.println(query);
				System.out.println("Entered i==0 if block");
				ResultSet res = stmt.executeQuery(query.toString());
				while (res.next()) {
					String[] op = new String[1];
					op[0] = (res.getString(1));
					System.out.println("Added " + res.getString(1) + " to op string");
					queries_.add(op);
				}
				res.close();
			}

			stmt.close();
			con.close();

		} catch (Exception ex) {
			ex.printStackTrace();
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
			// List<String[]> res = samplePrepare(queries,cols,i,db,tbl);
			queries = samplePrepare(queries, cols, i, db, tbl);

			for (String[] s : queries) {
				for (int m = 0; m < s.length; m++) {
					System.out.print(s[m] + ",");
				}
				System.out.println();
			}

			System.out.println(
					"Sampling preparation step " + i + " complete. Total no of queries: " + queries.size() + "\n");
		}
	}
}