package org.abhi.parakhi;

import java.io.File;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.api.client.auth.oauth2.Credential;

public class delCredentials extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String user_id = (String) request.getSession().getAttribute("user_id");

		File cred_file = new java.io.File(System.getProperty("user.home"),
				".credentials/sheets.googleapis.com-Parakhi/StoredCredential");

		if (cred_file.exists()) {
			cred_file.delete();
			request.getSession().setAttribute("credential", null);
			request.getSession().setAttribute("token", null);
			System.out.println("Deleted existing credentials for " + user_id);
		} else
			System.out.println("File " + cred_file.getAbsolutePath() + " does not exist");

		response.sendRedirect("index.jsp");
	}

}
