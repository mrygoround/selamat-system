package controller;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;

public class ShelterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String action = request.getParameter("action");
        String result = "error";

        try {
            Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
            String dbPath = getServletContext().getRealPath("/database/selamat_db");
            String url = "jdbc:derby:" + dbPath + ";create=true";
            Connection conn = DriverManager.getConnection(url);

            if ("add".equals(action)) {
                String name = request.getParameter("name");
                String location = request.getParameter("location");
                int capacity = Integer.parseInt(request.getParameter("capacity"));
                String status = request.getParameter("status");

                PreparedStatement pst = conn.prepareStatement(
                    "INSERT INTO SHELTER (SHELTER_NAME, LOCATION, CAPACITY, STATUS) VALUES (?, ?, ?, ?)"
                );
                pst.setString(1, name);
                pst.setString(2, location);
                pst.setInt(3, capacity);
                pst.setString(4, status);
                pst.executeUpdate();
                result = "success";

            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String name = request.getParameter("name");
                String location = request.getParameter("location");
                int capacity = Integer.parseInt(request.getParameter("capacity"));
                String status = request.getParameter("status");

                PreparedStatement pst = conn.prepareStatement(
                    "UPDATE SHELTER SET SHELTER_NAME=?, LOCATION=?, CAPACITY=?, STATUS=? WHERE ID=?"
                );
                pst.setString(1, name);
                pst.setString(2, location);
                pst.setInt(3, capacity);
                pst.setString(4, status);
                pst.setInt(5, id);
                pst.executeUpdate();
                result = "success";

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                PreparedStatement pst = conn.prepareStatement("DELETE FROM SHELTER WHERE ID=?");
                pst.setInt(1, id);
                pst.executeUpdate();
                result = "success";
            }

            conn.close();
        } catch (Exception e) {
            result = "error: " + e.getMessage();
        }

        response.setContentType("text/plain");
        response.getWriter().write(result);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
            String dbPath = getServletContext().getRealPath("/database/selamat_db");
            String url = "jdbc:derby:" + dbPath + ";create=true";
            Connection conn = DriverManager.getConnection(url);


            String sql = "SELECT * FROM SHELTER";
            PreparedStatement pst = conn.prepareStatement(sql);
            ResultSet rs = pst.executeQuery();

            StringBuilder json = new StringBuilder();
            json.append("[");
            boolean first = true;
            while (rs.next()) {
                if (!first) json.append(",");
                json.append("{")
                    .append("\"id\":" + rs.getInt("ID") + ",")
                    .append("\"name\":\"" + rs.getString("SHELTER_NAME") + "\",")
                    .append("\"location\":\"" + rs.getString("LOCATION") + "\",")
                    .append("\"capacity\":" + rs.getInt("CAPACITY") + ",")
                    .append("\"status\":\"" + rs.getString("STATUS") + "\"")
                    .append("}");
                first = false;
            }
            json.append("]");

            out.print(json.toString());
            conn.close();

        } catch (Exception e) {
            out.print("[]"); // Return empty array if error
        }

        out.flush();
    }
}
