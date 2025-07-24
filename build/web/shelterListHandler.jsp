<%@ page import="java.sql.*, org.json.*" %>
<%
response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");

JSONArray shelterArray = new JSONArray();
try {
    Class.forName("org.apache.derby.jdbc.ClientDriver");
    Connection conn = DriverManager.getConnection("jdbc:derby://localhost:1527/selamat_db", "app", "app");
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

    conn.close();
} catch (Exception e) {
    JSONObject err = new JSONObject();
    err.put("error", e.getMessage());
    shelterArray.put(err);
}

out.print(shelterArray.toString());
%>
