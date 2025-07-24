const toggleButton = document.querySelector('.nav-toggle');
const menu = document.querySelector('.nav-menu');

const tableBody = document.getElementById("tableBody");
const deleteBtn = document.getElementById("deleteBtn");
const deletePanel = document.getElementById("deletePanel");
const deleteForm = document.getElementById("deleteForm");

let shelters = []; // Will be fetched from server

toggleButton.addEventListener('click', () => {
  menu.classList.toggle('show');
});

async function renderTable() {
  tableBody.innerHTML = "";

  try {
    const response = await fetch("shelterListHandler.jsp");
    shelters = await response.json();

    shelters.forEach((shelter) => {
      const row = tableBody.insertRow();
      row.insertCell().textContent = shelter.id;
      row.insertCell().textContent = shelter.name;
      row.insertCell().textContent = shelter.location;
      row.insertCell().textContent = shelter.capacity;
      row.insertCell().textContent = shelter.status;
    });
  } catch (error) {
    console.error("Failed to load shelters:", error);
  }
}

function addShelter() {
  const name = prompt("Enter shelter name:");
  const location = prompt("Enter location:");
  const capacity = prompt("Enter capacity:");
  const statusOptions = ["Available", "Full", "Under Maintenance"];
  const statusIndex = prompt("Select status:\n1. Available\n2. Full\n3. Under Maintenance", "1") - 1;
  const status = statusOptions[statusIndex];

  if (name && location && capacity && status) {
    fetch("ShelterServlet", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: `action=add&name=${encodeURIComponent(name)}&location=${encodeURIComponent(location)}&capacity=${capacity}&status=${encodeURIComponent(status)}`
    })
    .then(response => response.text())
    .then(result => {
      if (result.includes("success")) {
        alert("Shelter added!");
        renderTable();
      } else {
        alert("Error: " + result);
      }
    });
  }
}

function editShelter() {
  const rowId = prompt("Enter shelter ID to edit:");
  if (!rowId) return;

  const row = Array.from(document.querySelectorAll("#shelterTable tbody tr"))
    .find(r => r.cells[0].textContent.trim() === rowId);

  if (!row) {
    alert("Shelter with ID " + rowId + " not found.");
    return;
  }

  const currentName = row.cells[1].textContent;
  const currentLocation = row.cells[2].textContent;
  const currentCapacity = row.cells[3].textContent;
  const currentStatus = row.cells[4].textContent;

  const name = prompt("Enter new name:", currentName);
  const location = prompt("Enter new location:", currentLocation);
  const capacity = prompt("Enter new capacity:", currentCapacity);
  const status = prompt("Enter new status (Available, Full, Under Maintenance):", currentStatus);

  if (name && location && capacity && status) {
    fetch("ShelterServlet", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: `action=edit&id=${rowId}&name=${encodeURIComponent(name)}&location=${encodeURIComponent(location)}&capacity=${capacity}&status=${encodeURIComponent(status)}`
    })
    .then(response => response.text())
    .then(result => {
      if (result.includes("success")) {
        alert("Shelter updated!");
        renderTable(); // reload table after edit
      } else {
        alert("Error: " + result);
      }
    });
  }
}



function showDeletePanel() {
  deleteForm.innerHTML = "";
  shelters.forEach((shelter) => {
    const label = document.createElement("label");
    const checkbox = document.createElement("input");
    checkbox.type = "checkbox";
    checkbox.value = shelter.id;
    checkbox.name = "deleteItem";
    label.appendChild(checkbox);
    label.appendChild(document.createTextNode(` ${shelter.id}. ${shelter.name} - ${shelter.location}`));
    deleteForm.appendChild(label);
  });
  deletePanel.style.display = "block";
}

function confirmDelete() {
  const selected = Array.from(deleteForm.querySelectorAll("input[name='deleteItem']:checked"))
    .map(cb => cb.value);

  if (selected.length === 0) {
    alert("No shelters selected.");
    return;
  }

  selected.forEach(id => {
    fetch("ShelterServlet", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: `action=delete&id=${id}`
    })
    .then(response => response.text())
    .then(result => {
      if (!result.includes("success")) {
        alert("Failed to delete ID: " + id);
      }
      renderTable();
    });
  });
  cancelDelete();
}

function cancelDelete() {
  deletePanel.style.display = "none";
  deleteForm.innerHTML = "";
}

deleteBtn.addEventListener("click", showDeletePanel);
renderTable();
