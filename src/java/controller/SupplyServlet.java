package controller;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import org.json.JSONArray;
import org.json.JSONObject;

public class SupplyServlet extends HttpServlet {

  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String action = request.getParameter("action");
    response.setContentType("text/plain");
    response.setCharacterEncoding("UTF-8");

    try {
        Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
        String dbPath = getServletContext().getRealPath("/database/selamat_db");
        String url = "jdbc:derby:" + dbPath + ";create=true";
        Connection conn = DriverManager.getConnection(url);


      if ("add".equals(action)) {
        PreparedStatement pst = conn.prepareStatement(
          "INSERT INTO SUPPLY (ITEM_NAME, QUANTITY, UNIT, STATUS, SHELTER_N) VALUES (?, ?, ?, ?, ?)"
        );
        pst.setString(1, request.getParameter("itemName"));
        pst.setInt(2, Integer.parseInt(request.getParameter("quantity")));
        pst.setString(3, request.getParameter("unit"));
        pst.setString(4, request.getParameter("status"));
        pst.setString(5, request.getParameter("shelter"));
        pst.executeUpdate();
        response.getWriter().write("success");

      } else if ("update".equals(action)) {
        PreparedStatement pst = conn.prepareStatement(
          "UPDATE SUPPLY SET ITEM_NAME=?, QUANTITY=?, UNIT=?, STATUS=?, SHELTER_N=? WHERE ID=?"
        );
        pst.setString(1, request.getParameter("itemName"));
        pst.setInt(2, Integer.parseInt(request.getParameter("quantity")));
        pst.setString(3, request.getParameter("unit"));
        pst.setString(4, request.getParameter("status"));
        pst.setString(5, request.getParameter("shelter"));
        pst.setInt(6, Integer.parseInt(request.getParameter("id")));
        pst.executeUpdate();
        response.getWriter().write("success");

      } else if ("delete".equals(action)) {
        String id = request.getParameter("id");
        PreparedStatement pst = conn.prepareStatement("DELETE FROM SUPPLY WHERE ID = ?");
        pst.setInt(1, Integer.parseInt(id));
        pst.executeUpdate();
        response.getWriter().write("success");
      }


      conn.close();
    } catch (Exception e) {
      response.getWriter().write("error: " + e.getMessage());
    }
  }

  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    JSONArray supplyList = new JSONArray();

    try {
        Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
        String dbPath = getServletContext().getRealPath("/database/selamat_db");
        String url = "jdbc:derby:" + dbPath + ";create=true";
        Connection conn = DriverManager.getConnection(url);


      Statement stmt = conn.createStatement();
      ResultSet rs = stmt.executeQuery("SELECT * FROM SUPPLY");

      while (rs.next()) {
        JSONObject obj = new JSONObject();
        obj.put("id", rs.getInt("ID"));
        obj.put("itemName", rs.getString("ITEM_NAME"));
        obj.put("quantity", rs.getInt("QUANTITY"));
        obj.put("unit", rs.getString("UNIT"));
        obj.put("status", rs.getString("STATUS"));
        obj.put("shelter", rs.getString("SHELTER_N"));
        supplyList.put(obj);
      }

      conn.close();
    } catch (Exception e) {
      JSONObject error = new JSONObject();
      error.put("error", e.getMessage());
      supplyList.put(error);
    }

    response.getWriter().write(supplyList.toString());
  }
}
