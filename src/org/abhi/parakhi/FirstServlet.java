package org.abhi.parakhi;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/FirstServelet")
public class FirstServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
/*	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Hello from GET method");
		PrintWriter writer = response.getWriter();
		writer.println("<h4>Hello in html from GET</h4>");
	}
*/	
protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Hello from POST method");
		String userName = request.getParameter("userName");
		
		HttpSession session = request.getSession();
		ServletContext context = request.getServletContext();
		if (userName != "" && userName != null){
			session.setAttribute("savedUserName", userName);
			context.setAttribute("savedUserName", userName);
		}
		PrintWriter writer = response.getWriter();
		writer.println("<h4>Hello " + userName + " in html from POST</h4><br>");
		writer.println("<h4>Hello " + (String)session.getAttribute("savedUserName") + " from session object</h4><br>");
		writer.println("<h4>Hello " + (String)context.getAttribute("savedUserName") + " from context object</h4><br>");
	}
}
