package org.abhi.parakhi;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class getAuthCode extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
 
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	System.out.println(request.getParameter("code"));
	System.out.println(request.getParameter("access_token"));
	System.out.println(request.getParameter("refresh_token"));
	
	//response.sendRedirect("index.jsp");
	}
	
//	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//		request.getParameter("code");
//		response.sendRedirect("https://www.googleapis.com/oauth2/v4/token?code4/GATgfnqv6WCcrlSh5BtEmHGbKQ6VHpBpKERawj3_4Lw&client_id=516645433666-udfapbsstamr2m2n1145urn0geo69lmm.apps.googleusercontent.com&client_secret=Vp_KA171b-2neXlVf_5lgF_s&redirect_uri=http://localhost:8080/Parakhi/getAuthCode&grant_type=authorization_code");
//	}

}
