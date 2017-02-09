package org.abhi.parakhi;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub

		String uname = request.getParameter("uname");
		String pass = request.getParameter("pass");

		if ("parakhi".equals(uname) && "abc".equals(pass)) {
			request.getSession().setAttribute("user_id", uname);
			response.sendRedirect("index.jsp");
		} else {
			response.sendRedirect("login.jsp");

		}

	}

}
