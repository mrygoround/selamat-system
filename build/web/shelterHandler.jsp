<%@page contentType="application/json"%>
<%@page import="java.sql.*" %>
<%@page import="org.json.JSONArray" %>
<%@page import="org.json.JSONObject" %>
<%
    JSONArray shelterList = new JSONArray();

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/selamat_db", "app", "app");
        String sql = "SELECT * FROM SHELTER";
        PreparedStatement pst = conn.prepareStatement(sql);
        ResultSet rs = pst.executeQuery();

        while (rs.next()) {
            JSONObject obj = new JSONObject();
            obj.put("id", rs.getInt("ID"));
            obj.put("name", rs.getString("SHELTER_NAME"));
            obj.put("location", rs.getString("LOCATION"));
            obj.put("capacity", rs.getInt("CAPACITY"));
            obj.put("status", rs.getString("STATUS"));
            shelterList.put(obj);
        }

        if (shelterList.length() == 0) {
            JSONObject empty = new JSONObject();
           empty.put("notice", "No data found");
            shelterList.put(empty);
        }
        
        rs.close();
        pst.close();
        conn.close();
    } catch (Exception e) {
        JSONObject error = new JSONObject();
        error.put("error", e.getMessage());
        shelterList.put(error);
    }

    out.print(shelterList.toString());
%>
