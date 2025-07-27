<%@ page import="java.sql.*, org.json.*" %>
<%
response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");

JSONArray shelterArray = new JSONArray();
try {
    String dbPath = application.getRealPath("/database/selamat_db");
    String dbURL = "jdbc:derby:" + dbPath + ";create=true";

    Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
    Connection conn = DriverManager.getConnection(dbURL);
    
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM SHELTER");

    while (rs.next()) {
        JSONObject obj = new JSONObject();
        obj.put("id", rs.getInt("ID"));
        obj.put("name", rs.getString("SHELTER_NAME"));
        obj.put("location", rs.getString("LOCATION"));
        obj.put("capacity", rs.getInt("CAPACITY"));   
        obj.put("status", rs.getString("STATUS"));
        shelterArray.put(obj);
    }

    rs.close();
    stmt.close();
    conn.close();
} catch (Exception e) {
    JSONObject err = new JSONObject();
    err.put("error", e.getMessage());
    shelterArray.put(err);
}

out.print(shelterArray.toString());
%>
