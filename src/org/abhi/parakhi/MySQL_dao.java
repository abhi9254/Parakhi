package org.abhi.parakhi;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class MySQL_dao {

	private DataSource dataSource;
	private Connection connection;
	private Statement statement;

	public MySQL_dao() {

		try {
			Context initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("mysql_pool");
		} catch (NamingException e) {
			e.printStackTrace();
		}
	}

	public List<String[]> getProjects() {
		ResultSet resultSet = null;
		List<String[]> projects = new ArrayList<String[]>();
		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();
			String query = "SELECT DISTINCT project_id,project_name,project_desc FROM parakhi.myprojects";
			resultSet = statement.executeQuery(query);
			String[] s;
			while (resultSet.next()) {
				s = new String[3];
				s[0] = resultSet.getString(1);
				s[1] = resultSet.getString(2);
				s[2] = resultSet.getString(3);
				projects.add(s);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (connection != null) {
				try {
					connection.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		return projects;
	}

	public List<String[]> getTestsheets(int p_id) {
		ResultSet resultSet = null;
		List<String[]> ts = new ArrayList<String[]>();
		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();
			String query = "SELECT DISTINCT test_sheet_id,test_sheet_title FROM parakhi.mytestsheets WHERE project_id ="
					+ p_id;
			resultSet = statement.executeQuery(query);
			String[] s;
			while (resultSet.next()) {
				s = new String[3];
				s[0] = resultSet.getString(1);
				s[1] = resultSet.getString(2);
				ts.add(s);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (connection != null) {
				try {
					connection.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		return ts;
	}

	public List<String[]> getCases(int project_id) {

		ResultSet resultSet = null;
		List<String[]> cases = new ArrayList<String[]>();
		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();
			String query = "SELECT case_id,case_name,case_desc FROM parakhi.mytests where project_id=0 OR project_id="
					+ project_id;
			resultSet = statement.executeQuery(query);
			String[] s;
			while (resultSet.next()) {
				s = new String[3];
				s[0] = resultSet.getString(1);
				s[1] = resultSet.getString(2);
				s[2] = resultSet.getString(3);
				cases.add(s);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (connection != null) {
				try {
					connection.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		return cases;
	}

	public String getQueryText(int case_id) {

		ResultSet resultSet = null;
		StringBuilder query_text = new StringBuilder("");
		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();
			String query = "SELECT case_query FROM parakhi.mytests where case_id=" + case_id;
			resultSet = statement.executeQuery(query);

			while (resultSet.next()) {
				query_text.append(resultSet.getString(1));

			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (connection != null) {
				try {
					connection.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		return query_text.toString();
	}

	public List<String> getProjDbNames(int proj_id) {
		ResultSet resultSet = null;
		List<String> db_nms = new ArrayList<String>();
		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();
			String query = "SELECT DISTINCT db_nm FROM parakhi.mytables where project_id=" + proj_id;
			resultSet = statement.executeQuery(query);

			while (resultSet.next()) {
				db_nms.add(resultSet.getString(1));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (connection != null) {
				try {
					connection.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		return db_nms;
	}

	public String[] getDbTblNames(int proj_id, String db_nm) {
		ResultSet resultSet = null;
		String[] tbls_ = null;

		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();
			String query = "SELECT DISTINCT tbl_nm FROM parakhi.mytables where project_id=" + proj_id + " and db_nm='"
					+ db_nm + "'";
			resultSet = statement.executeQuery(query);
			List<String> tbls = new ArrayList<String>();
			while (resultSet.next()) {
				tbls.add(resultSet.getString(1));
			}
			int len = tbls.size();

			tbls_ = new String[len];
			for (int i = 0; i < len; i++)
				tbls_[i] = tbls.get(i);

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (connection != null) {
				try {
					connection.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}

		return tbls_;
	}

	public List<String[]> getTbl_Columns(String db_nm, String tbl_nm) {
		ResultSet resultSet = null;
		List<String[]> col_nms = new ArrayList<String[]>();
		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();
			String query = "SELECT DISTINCT target_col_nm,target_data_typ,source_tbl_nm,source_col_nm FROM parakhi.mystms where stm_nm='"
					+ db_nm + "." + tbl_nm + "'";
			resultSet = statement.executeQuery(query);
			String[] s;

			while (resultSet.next()) {
				s = new String[4];
				s[0] = resultSet.getString(1);
				s[1] = resultSet.getString(2);
				s[2] = resultSet.getString(3);
				s[3] = resultSet.getString(4);
				col_nms.add(s);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (connection != null) {
				try {
					connection.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		return col_nms;

	}

	public boolean insertIntoProjects(Integer p_id, String p_name, String p_desc, String db_name, String tbl_name) {
		boolean returnCode = true;
		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();
			String query = "INSERT INTO parakhi.myprojects VALUES(" + p_id + ",'" + p_name + "','" + p_desc + "','"
					+ db_name + "','" + tbl_name + "')";
			System.out.println(query);
			statement.executeUpdate(query);
			connection.close();
		} catch (Exception e) {
			e.printStackTrace();
			returnCode = false;
		}
		return returnCode;
	}

	public boolean insertIntoTables(Integer p_id, String db_name, String tbl_name, String col_name) {
		boolean returnCode = true;
		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();
			String query = "INSERT INTO parakhi.mytables VALUES(" + p_id + ",'" + db_name + "','" + tbl_name + "','"
					+ col_name + "')";
			System.out.println(query);
			statement.executeUpdate(query);
			connection.close();
		} catch (Exception e) {
			e.printStackTrace();
			returnCode = false;
		}
		return returnCode;
	}

	public boolean insertIntoSTMs(String stm_id, String stm_nm, String stm_version, String serial_no,
			String source_db_nm, String source_tbl_nm, String source_col_nm, String source_data_typ,
			String transformation, String target_db_nm, String target_tbl_nm, String target_col_nm,
			String target_data_typ, String comment) {
		boolean returnCode = true;
		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();
			String query = "INSERT INTO parakhi.mystms VALUES('" + stm_id + "','" + stm_nm + "','" + stm_version + "','"
					+ serial_no + "','" + source_db_nm + "','" + source_tbl_nm + "','" + source_col_nm + "','"
					+ source_data_typ + "','" + transformation + "','" + target_db_nm + "','" + target_tbl_nm + "','"
					+ target_col_nm + "','" + target_data_typ + "','" + comment + "')";
			System.out.println(query);
			statement.executeUpdate(query);
			connection.close();
		} catch (Exception e) {
			e.printStackTrace();
			returnCode = false;
		}
		return returnCode;
	}

	public boolean checkUserExists(String user_id) {
		boolean returnCode = true;
		ResultSet res = null;
		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();

			String query = "select user_id from parakhi.myusers WHERE user_id = '" + user_id + "'";
			System.out.println(query);
			res = statement.executeQuery(query);
			if (!res.next())
				returnCode = false;
			connection.close();
		} catch (Exception e) {
			e.printStackTrace();
			returnCode = false;
		}
		return returnCode;
	}

	public String getUserToken(String user_id) {
		String token = null;
		ResultSet res = null;
		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();

			String query = "select refresh_token from parakhi.myusers WHERE user_id = '" + user_id + "'";
			// System.out.println(query);
			res = statement.executeQuery(query);
			if (res.next())
				token = res.getString(1);
			else
				token = "unknown user";
			connection.close();
		} catch (Exception e) {
			e.printStackTrace();
			token = "exeption";
		}
		return token;
	}

	public boolean insertIntoUsers(String user_id, String access_token, String refresh_token) {
		boolean returnCode = true;
		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();
			String query = "INSERT INTO parakhi.myusers VALUES('" + user_id + "','" + access_token + "','"
					+ refresh_token + "')";
			System.out.println(query);
			statement.executeUpdate(query);
			connection.close();
		} catch (Exception e) {
			e.printStackTrace();
			returnCode = false;
		}
		return returnCode;
	}

	public boolean updateIntoUsers(String user_id, String access_token, String refresh_token) {
		boolean returnCode = true;
		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();
			String query = "UPDATE parakhi.myusers SET access_token = '" + access_token + "',refresh_token = '"
					+ refresh_token + " where user_id = '" + user_id + "'";
			System.out.println(query);
			statement.executeUpdate(query);
			connection.close();
		} catch (Exception e) {
			e.printStackTrace();
			returnCode = false;
		}
		return returnCode;
	}

	public List<String> traceTblNm_for_Src_Tbls(String tbl_nm) {
		// System.out.println("in tbl trace dao");
		List<String> db_nms = new ArrayList<String>();
		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();
			String query = "select DISTINCT CONCAT(source_db_nm,'.',source_tbl_nm,' ',source_col_nm) from parakhi.mystms where CONCAT(TRIM(target_db_nm),'.',TRIM(target_tbl_nm)) = '"
					+ tbl_nm + "'";
			// System.out.println(query);
			ResultSet resultSet = statement.executeQuery(query);
			while (resultSet.next()) {
				db_nms.add(resultSet.getString(1));
				// System.out.println("Added " + resultSet.getString(1));
			}

			connection.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return db_nms;

	}

	public List<String> traceTblNm_for_Src_Cols(String trace_tbl_nm, String src_tbl_nm) {
		System.out.println("in col trace dao");
		List<String> tbl_nms = new ArrayList<String>();
		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();
			String query = "select DISTINCT source_col_nm from parakhi.mystms where CONCAT(TRIM(target_db_nm),'.',TRIM(target_tbl_nm)) = '"
					+ trace_tbl_nm + "' AND CONCAT(source_db_nm,'.',source_tbl_nm)='" + src_tbl_nm + "'";
			System.out.println(query);
			ResultSet resultSet = statement.executeQuery(query);
			while (resultSet.next()) {
				tbl_nms.add(resultSet.getString(1));
				System.out.println("Added " + resultSet.getString(1));
			}

			connection.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return tbl_nms;

	}

	public boolean updateTaskProgress(int task_id, int progress) {
		boolean returnCode = true;
		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();
			String query = "UPDATE parakhi.mytasks SET progress = " + progress + " where task_id = " + task_id ;
			System.out.println(query);
			statement.executeUpdate(query);
			connection.close();
		} catch (Exception e) {
			e.printStackTrace();
			returnCode = false;
		}
		return returnCode;
		
	}
	
	public List<String[]> getTasks(){
		
		ResultSet resultSet = null;
		List<String[]> tasks = new ArrayList<String[]>();
		try {
			connection = dataSource.getConnection();
			statement = connection.createStatement();
			String query = "SELECT DISTINCT task_id,progress FROM parakhi.mytasks";
			resultSet = statement.executeQuery(query);
			String[] s;

			while (resultSet.next()) {
				s = new String[2];
				s[0] = resultSet.getString(1);
				s[1] = resultSet.getString(2);
				tasks.add(s);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if (connection != null) {
				try {
					connection.close();
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}
		}
		return tasks;
	}

}

class Cases {
	int case_id;
	String case_name;
	int project_id;
	String project_name;
	String case_desc;
	String case_query;
	String case_author;
}

class Tbl_columns {
	String tbl_nm;
	String col_nm;
}