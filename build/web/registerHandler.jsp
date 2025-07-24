<%@page import="java.sql.*"%>
<%
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String confirm = request.getParameter("confirm");

    out.println("Handler reached!<br>");
    out.println("Received username: " + username + "<br>");
    out.println("Received email: " + email + "<br>");

    if (!password.equals(confirm)) {
        out.println("<script>alert('Passwords do not match!'); window.location='register.jsp';</script>");
        return;
    }

    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        Class.forName("org.apache.derby.jdbc.EmbeddedDriver");
        String dbPath = application.getRealPath("/database/selamat_db");
        String url = "jdbc:derby:" + dbPath + ";create=true";
        conn = DriverManager.getConnection(url);

        // Semak sama ada username sudah wujud
        String checkSql = "SELECT * FROM USERS WHERE USERNAME=?";
        pst = conn.prepareStatement(checkSql);
        pst.setString(1, username);
        rs = pst.executeQuery();

        if (rs.next()) {
            out.println("Username already exists.<br>");
            out.println("<script>alert('Username already exists'); window.location='register.jsp';</script>");
        } else {
            if (pst != null) pst.close(); // tutup statement lama

            // Masukkan pengguna baru
            String insert = "INSERT INTO USERS (USERNAME, PASSWORD, EMAIL) VALUES (?, ?, ?)";
            pst = conn.prepareStatement(insert);
            pst.setString(1, username);
            pst.setString(2, password);
            pst.setString(3, email);

            int rowInserted = pst.executeUpdate();
            if (rowInserted > 0) {
                out.println("Data inserted!<br>");
                out.println("<script>alert('Registration successful'); window.location='login.jsp';</script>");
            } else {
                out.println("Insert failed!<br>");
            }
        }

    } catch (Exception e) {
        out.println("Exception: " + e.getMessage() + "<br>");
        e.printStackTrace(); // Cetak error ke server log
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) {}
        if (pst != null) try { pst.close(); } catch (SQLException e) {}
        if (conn != null) try { conn.close(); } catch (SQLException e) {}
    }
%>
