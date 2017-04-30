package org.abhi.parakhi;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Logout extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		if (request.getSession() != null) {
			// request.getSession().setAttribute("user_id", null);
			// request.getSession().setAttribute("proj_id", null);
			// request.getSession().setAttribute("proj_nm", null);
			request.getSession().invalidate();
			response.sendRedirect("login.jsp");
		} else {
			response.sendRedirect("login.jsp");

		}

	}

}
