<%
    String user = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (user == null || role == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Dashboard - SELAMAT System</title>
  <link rel="stylesheet" href="css/dashboard.css" />
</head>
<body>

<nav>
  <div class="nav-container">
    <a href="dashboard.jsp" class="nav-logo">SELAMAT</a>
    <button class="nav-toggle" aria-label="Toggle menu">&#9776;</button>
    <ul class="nav-menu">
      <% if ("admin".equals(role)) { %>
        <li><a href="shelter.jsp">Manage Shelters</a></li>
        <li><a href="booking.jsp">Manage Bookings</a></li>
        <li><a href="supply.jsp">Manage Supplies</a></li>
      <% } else { %>
        <li><a href="booking.jsp">My Bookings</a></li>
      <% } %>
      <li><a href="logout.jsp" class="logout-button">Logout</a></li>
    </ul>
  </div>
</nav>

<main class="main-content">
  <section class="intro">
    <h1>Welcome, <%= user %>!</h1>
    <p>SELAMAT is an integrated Emergency Shelter Booking & Supply Management System designed to coordinate and support disaster relief operations efficiently.</p>
  </section>

  <section class="shelter-section">
    <h2>Available Emergency Shelters</h2>
    <table id="shelterTable">
      <thead>
        <tr>
          <th>ID</th>
          <th>Name</th>
          <th>Location</th>
          <th>Capacity</th>
          <th>Status</th>
        </tr>
      </thead>
      <tbody id="tableBody">
        <!-- Shelter data populated via JS -->
      </tbody>
    </table>
  </section>
</main>

<script src="js/dashboard.js"></script>
</body>
</html>
