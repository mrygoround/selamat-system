<%@ page session="true" %>
<%
  String userRole = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Booking - SELAMAT</title>
  <link rel="stylesheet" href="css/booking.css" />
  
</head>
<body>
  <nav>
  <div class="nav-container">
    <a href="dashboard.jsp" class="nav-logo">SELAMAT</a>
    <button class="nav-toggle" aria-label="Toggle menu">
      &#9776;
    </button>
    <ul class="nav-menu">
      <% if ("user".equals(userRole)) { %>
        <li><a href="booking.jsp">Booking</a></li>
      <% } else { %>
        <li><a href="shelter.jsp">Shelter</a></li>
        <li><a href="booking.jsp">Booking</a></li>
        <li><a href="supply.jsp">Supply</a></li>
      <% } %>
      <li><a href="logout.jsp" class="logout-button">Logout</a></li>
    </ul>
  </div>
</nav>
  

  <div class="container">
    <h2>Booking Management</h2>

    <div class="tabs">
      <div class="tab active" data-tab="create">Create Booking</div>
      <div class="tab" data-tab="view">View Bookings</div>
    </div>

    <div id="create" class="tab-content">
      <form id="bookingForm">
        <label for="name">Name</label>
        <input type="text" id="name" required />

        <label for="email">Email</label>
        <input type="email" id="email" required />

        <label for="shelter">Select Shelter</label>
        <select id="shelter" required>
          <!-- Shelters populated by JS -->
        </select>

        <label for="startDate">Start Date</label>
        <input type="date" id="startDate" required />

        <label for="endDate">End Date</label>
        <input type="date" id="endDate" required />

        <label for="people">Number of People</label>
        <input type="number" id="people" min="1" required />

        <button type="submit">Create Booking</button>
      </form>
    </div>

    <div id="view" class="tab-content" style="display:none;">
      <table>
        <thead>
          <tr>
            <th>Booking ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Shelter</th>
            <th>Start Date</th>
            <th>End Date</th>
            <th>People</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody id="bookingTableBody"></tbody>
      </table>
    </div>
  </div>

 <script src="js/booking.js"></script>
</body>
</html>
