<%@page import="java.sql.*"%>
<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        // Special case: Admin login (hardcoded)
        if ("admin".equals(username) && "admin".equals(password)) {
            session.setAttribute("username", "admin");
            session.setAttribute("role", "admin");
            response.sendRedirect("dashboard.jsp");
            return;
        }

        Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
        String dbPath = application.getRealPath("/database/selamat_db");
        String url = "jdbc:derby:" + dbPath + ";create=true";
        conn = DriverManager.getConnection(url);

        String sql = "SELECT * FROM USERS WHERE (USERNAME=? OR EMAIL=?) AND PASSWORD=?";
        pst = conn.prepareStatement(sql);
        pst.setString(1, username);
        pst.setString(2, username);
        pst.setString(3, password);
        rs = pst.executeQuery();

        if (rs.next()) {
            session.setAttribute("username", username);
            session.setAttribute("role", "user");
            response.sendRedirect("dashboard.jsp");
        } else {
            out.println("<script>alert('Invalid username or password!'); window.location='login.jsp';</script>");
        }

    } catch (Exception e) {
        out.println("Login Error: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (pst != null) pst.close();
        if (conn != null) conn.close();
    }
%>
