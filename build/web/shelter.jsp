<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Shelter Availability - SELAMAT</title>
  <link rel="stylesheet" href="css/shelter.css" />
  
</head>
<body>
  <nav>
    <div class="nav-container">
      <a href="dashboard.jsp" class="nav-logo">SELAMAT</a>  
      <button class="nav-toggle" aria-label="Toggle menu">
        &#9776;
      </button>
      <ul class="nav-menu">
        <li><a href="shelter.jsp">Shelter</a></li>
        <li><a href="booking.jsp">Booking</a></li>
        <li><a href="supply.jsp">Supply</a></li>
        <li><a href="logout.jsp" class="logout-button">Logout</a></li>
      </ul>
    </div>
  </nav>

  <div class="container">
    <h2>Shelter Availability</h2>

    <div id="deletePanel">
      <div class="delete-header">
        🗑️ <strong>Select Shelters to Delete</strong>
      </div>
      <form id="deleteForm" class="delete-grid"></form>
      <div class="delete-actions">
        <button class="confirm" onclick="confirmDelete()">Confirm Delete</button>
        <button class="cancel" onclick="cancelDelete()">Cancel</button>
      </div>
    </div>

    <div class="button-group">
      <button class="add-btn" onclick="addShelter()">Add</button>
      <button class="edit-btn" onclick="editShelter()">Edit</button>
      <button class="delete-btn" id="deleteBtn">Delete</button>
    </div>

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
      <tbody id="tableBody"></tbody>
    </table>
  </div>

  

  <script src="js/shelter.js"></script>
</body>
</html>
