package org.abhi.parakhi;

import java.io.IOException;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.abhi.parakhi.SheetsAPI;
import org.abhi.parakhi.MySQL_dao;

public class CreateProject extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final Pattern p = Pattern.compile("spreadsheets/d/.*/");
	private String stm_sheet_id;
	private String test_sheet_id;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Integer p_id = Integer.parseInt(request.getParameter("pid"));
		String p_name = request.getParameter("pname");
		String p_desc = request.getParameter("pdesc");
		String stm_url = request.getParameter("stm_url");
		String stm_title = request.getParameter("stm_title");
		String ts_url = request.getParameter("testSheet_url");
		String ts_title = request.getParameter("testSheet_title");
		String[] selected_ws = new String[1];
		selected_ws[0] = "db_gold.gold_sales_dly";
		// request.getParameterValues("ws");

		// System.out.println(p_id +":"+ p_name +": "+ stm_url+"\n"+ts_url);

		Matcher m = p.matcher(stm_url);
		System.out.println("Worksheets selected");
		for (String ws : selected_ws)
			System.out.println(ws);

		if (m.find()) {
			// System.out.println(m.group());
			stm_sheet_id = m.group().substring(15, m.group().length() - 1);
			System.out.println("Stm Id retrieved: " + stm_sheet_id);
		}

		m=p.matcher(ts_url);
		
		if (m.find()) {
			// System.out.println(m.group());
			test_sheet_id = m.group().substring(15, m.group().length() - 1);
			}
		
		SheetsAPI ob = new SheetsAPI();

		// String stm_title =
		// ob.getSheetTitle(request.getSession().getAttribute("user_id").toString(),
		// (String) request.getSession().getAttribute("token"), stm_sheet_id);
		// String ts_title =
		// ob.getSheetTitle(request.getSession().getAttribute("user_id").toString(),
		// (String) request.getSession().getAttribute("token"), stm_sheet_id);

		/*
		 * //parse headers of sheet List<List<String>> parse_headers =
		 * ob.readSheetData((String) request.getSession().getAttribute("token"),
		 * stm_sheet_id, selected_ws[0] + "!A1:M4"); // Reading headers of STM
		 * StringBuilder s = new StringBuilder(""); for (List<String> row :
		 * parse_headers) { for (String cell : row) { s.append(cell + " "); } }
		 * System.out.println(s.toString());
		 */
		// Read source databases and tables from STM by interactive
		// column-selection
		String src_range = selected_ws[0] + "!A4:K12";
		List<List<String>> stm = ob.readSheetData((String) request.getSession().getAttribute("token"), stm_sheet_id,
				src_range);

		// Map<String,String> db_col_pairs = new HashMap<String,String>();
		// for(List<String> row:src_db_cols){
		// // key: table_name value: db_name
		// db_col_pairs.put(row.get(1), row.get(0));
		// }

		MySQL_dao ob2 = new MySQL_dao();
		ob2.insertIntoStmSheets(p_id, p_name, stm_sheet_id, stm_title, stm_url);
		ob2.insertIntoTestSheets(p_id, p_name, test_sheet_id, ts_title, ts_url);
		
		for (List<String> row : stm) {
			ob2.insertIntoProjects(p_id, p_name, p_desc, row.get(6), row.get(7));
			ob2.insertIntoProjects(p_id, p_name, p_desc, row.get(1), row.get(2));
			ob2.insertIntoTables(p_id, row.get(1), row.get(2), row.get(3));
			ob2.insertIntoTables(p_id, row.get(6), row.get(7), row.get(8));
			ob2.insertIntoSTMs(stm_sheet_id, selected_ws[0], "1.0", row.get(0), row.get(1), row.get(2), row.get(3),
					row.get(4), row.get(5), row.get(6), row.get(7), row.get(8), row.get(9), "Test comment");
		}
		request.getSession().setAttribute("proj_id", p_id);
		request.getSession().setAttribute("proj_nm", p_name);
		response.sendRedirect("project.jsp");
	}

}
