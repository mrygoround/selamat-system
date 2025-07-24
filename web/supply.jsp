<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Supply Inventory - SELAMAT</title>
  <link rel="stylesheet" href="css/supply.css" />
  
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
    <h2>Supply Inventory</h2>

    <div class="button-group">
      <button id="addBtn">Add</button>
      <button id="updateBtn">Update</button>
      <button id="deleteBtn">Delete</button>
    </div>

    <div class="delete-panel" id="deletePanel">
      <strong>Select Supplies to Delete:</strong>
      <form id="deleteForm"></form>
      <div class="delete-actions">
        <button class="confirm" id="confirmDeleteBtn">Confirm Delete</button>
        <button class="cancel" id="cancelDeleteBtn">Cancel</button>
      </div>
    </div>

    <table>
      <thead>
        <tr>
          <th><input type="checkbox" id="selectAll"/></th>
          <th>ID</th>
          <th>Item Name</th>
          <th>Quantity</th>
          <th>Unit</th>
          <th>Status</th>
          <th>Shelter</th>
        </tr>
      </thead>
      <tbody id="supplyTableBody"></tbody>
    </table>
  </div>

  <!-- Modal for Add/Update -->
  <div class="modal" id="modal">
    <div class="modal-content">
      <h3 id="modalTitle">Add Supply</h3>
      <form id="modalForm">
        <label for="itemName">Item Name:</label>
        <input type="text" id="itemName" required />

        <label for="quantity">Quantity:</label>
        <input type="number" id="quantity" min="0" required />

        <label for="unit">Unit:</label>
        <input type="text" id="unit" required />

        <label for="status">Status:</label>
        <select id="status" required>
          <option value="Available">Available</option>
          <option value="Low Stock">Low Stock</option>
          <option value="Out of Stock">Out of Stock</option>
        </select>

        <label for="shelterSelect">Shelter:</label>
        <select id="shelterSelect" required>
          <!-- Shelters options will be populated by JS -->
        </select>

        <div class="modal-buttons">
          <button type="submit" class="save-btn">Save</button>
          <button type="button" class="cancel-btn" id="cancelModalBtn">Cancel</button>
        </div>
      </form>
    </div>
  </div>

  
 <script src="js/supply.js"></script>
</body>
</html>
