package org.abhi.parakhi;

import org.apache.http.*;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class CoordinatorAPI {

	public String getLastSuccessfulRunBatchId(String flow_id,
			String last_job_id) {
		DefaultHttpClient httpclient = new DefaultHttpClient();
		String output = "";
		try {
			// specify the host, protocol, and port
			HttpHost target = new HttpHost("10.200.99.242", 9002, "http");

			// specify the get request
			HttpPost getRequest = new HttpPost(
					"/api/authentication?j_username=admin&j_password=admin&submit=Login&remember-me=true");

			HttpResponse httpResponse = httpclient.execute(target, getRequest);
			HttpEntity entity = httpResponse.getEntity();

			System.out.println(
					"################# COORDINATOR API ########################");

			getRequest.abort();

			String url = "/api/batchs/lastSuccessfulBatchId/dev/" + flow_id
					+ "/" + last_job_id;

			HttpGet getRequest1 = new HttpGet(url);

			System.out.println("executing request to " + target);

			HttpResponse httpResponse1 = httpclient.execute(target,
					getRequest1);
			HttpEntity entity1 = httpResponse1.getEntity();

			BufferedReader br = new BufferedReader(
					new InputStreamReader((entity1.getContent())));

			// System.out.println("Output from Server .... \n");
			String out = "";
			while ((out = br.readLine()) != null) {
				output = output + out;
			}

		} catch (Exception e) {
			output = null;
			e.printStackTrace();
		} finally {
			httpclient.getConnectionManager().shutdown();
		}
		return output;

	}

	public String[] getBatchIdDetails(String batch_id) {
		DefaultHttpClient httpclient = new DefaultHttpClient();
		String output[] = new String[3];
		String op = "";
		try {
			// specify the host, protocol, and port
			HttpHost target = new HttpHost("10.200.99.242", 9002, "http");

			// specify the get request
			HttpPost getRequest = new HttpPost(
					"/api/authentication?j_username=admin&j_password=admin&submit=Login&remember-me=true");

			HttpResponse httpResponse = httpclient.execute(target, getRequest);
			HttpEntity entity = httpResponse.getEntity();

			System.out.println(
					"################# COORDINATOR API ########################");

			getRequest.abort();

			String url = "/api/batchs/" + batch_id;

			HttpGet getRequest1 = new HttpGet(url);

			System.out.println("executing request to " + target);

			HttpResponse httpResponse1 = httpclient.execute(target,
					getRequest1);
			HttpEntity entity1 = httpResponse1.getEntity();

			BufferedReader br = new BufferedReader(
					new InputStreamReader((entity1.getContent())));

			// System.out.println("Output from Server .... \n");
			String out = "";
			while ((out = br.readLine()) != null) {
				op = op + out;
			}

		} catch (Exception e) {
			op = e.toString();
			e.printStackTrace();
		} finally {
			httpclient.getConnectionManager().shutdown();
		}
		JSONObject obj = new JSONObject(op);
		output[0] = obj.getString("startTime");
		output[1] = obj.getString("endTime");
		output[2] = ""+obj.getJSONObject("flowInstance").getInt("id");
		return output;

	}


}
