package controller;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import org.json.JSONArray;
import org.json.JSONObject;

public class BookingServlet extends HttpServlet {

  protected void doPost(HttpServletRequest request, HttpServletResponse response)
  throws ServletException, IOException {

  response.setContentType("text/plain");
  String action = request.getParameter("action");
  String result = "error";

  try {
    Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
    String dbPath = getServletContext().getRealPath("/database/selamat_db");
    System.out.println("DB Path used: " + dbPath);
    String url = "jdbc:derby:" + dbPath + ";create=true";
    Connection conn = DriverManager.getConnection(url);

    if ("create".equalsIgnoreCase(action)) {
      String name = request.getParameter("name");
      String email = request.getParameter("email");
      String shelterIdStr = request.getParameter("shelterId");
      String startDate = request.getParameter("startDate");
      String endDate = request.getParameter("endDate");
      String peopleStr = request.getParameter("people");

      // Tarik dari session sahaja, tidak perlu dari form
      String username = (String) request.getSession().getAttribute("username");

      if (name != null && email != null && shelterIdStr != null &&
          startDate != null && endDate != null && peopleStr != null && username != null) {

        int shelterId = Integer.parseInt(shelterIdStr);
        int people = Integer.parseInt(peopleStr);

        PreparedStatement pst = conn.prepareStatement(
          "INSERT INTO BOOKING (NAME, EMAIL, SHELTER_ID, START_DATE, END_DATE, PEOPLE, STATUS, USERNAME) " +
          "VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

        pst.setString(1, name);
        pst.setString(2, email);
        pst.setInt(3, shelterId);
        pst.setDate(4, Date.valueOf(startDate));
        pst.setDate(5, Date.valueOf(endDate));
        pst.setInt(6, people);
        pst.setString(7, "Active");
        pst.setString(8, username); 

        pst.executeUpdate();
        result = "success";
      } else {
        result = "error: missing parameters or user not logged in";
      }

    } else if ("cancel".equalsIgnoreCase(action)) {
      String idStr = request.getParameter("id");
      if (idStr != null) {
        int id = Integer.parseInt(idStr);
        PreparedStatement pst = conn.prepareStatement(
            "UPDATE BOOKING SET STATUS='Cancelled' WHERE ID=?");
        pst.setInt(1, id);
        pst.executeUpdate();
        result = "success";
      } else {
        result = "error: missing booking ID";
      }
    }

    conn.close();
  } catch (Exception e) {
    e.printStackTrace(); // view in NetBeans Output window
    result = "error: " + e.getMessage();
  }

  response.getWriter().write(result);
}


  protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

    response.setContentType("application/json");
    JSONArray bookings = new JSONArray();

    try {
      Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
      String dbPath = getServletContext().getRealPath("/database/selamat_db");
      System.out.println("Using DB path: " + dbPath);
      String url = "jdbc:derby:" + dbPath + ";create=true";
      Connection conn = DriverManager.getConnection(url);

      HttpSession session = request.getSession(false);
      String username = (session != null) ? (String) session.getAttribute("username") : null;

      PreparedStatement pst;

      if (username != null && !username.equalsIgnoreCase("admin")) {
        pst = conn.prepareStatement(
          "SELECT B.ID, B.NAME, B.EMAIL, S.SHELTER_NAME, B.START_DATE, B.END_DATE, B.PEOPLE, B.STATUS " +
          "FROM BOOKING B JOIN SHELTER S ON B.SHELTER_ID = S.ID WHERE B.USERNAME = ?"
        );
        pst.setString(1, username);
      } else {
        // Admin or no login — show all bookings
        pst = conn.prepareStatement(
          "SELECT B.ID, B.NAME, B.EMAIL, S.SHELTER_NAME, B.START_DATE, B.END_DATE, B.PEOPLE, B.STATUS " +
          "FROM BOOKING B JOIN SHELTER S ON B.SHELTER_ID = S.ID"
        );
      }

      ResultSet rs = pst.executeQuery();

      while (rs.next()) {
        JSONObject obj = new JSONObject();
        obj.put("id", rs.getInt("ID"));
        obj.put("name", rs.getString("NAME"));
        obj.put("email", rs.getString("EMAIL"));
        obj.put("shelterName", rs.getString("SHELTER_NAME"));
        obj.put("startDate", rs.getDate("START_DATE").toString());
        obj.put("endDate", rs.getDate("END_DATE").toString());
        obj.put("people", rs.getInt("PEOPLE"));
        obj.put("status", rs.getString("STATUS"));
        bookings.put(obj);
      }

      conn.close();
    } catch (Exception e) {
      JSONObject err = new JSONObject();
      err.put("error", e.getMessage());
      bookings.put(err);
    }

    response.getWriter().write(bookings.toString());
  }

}
