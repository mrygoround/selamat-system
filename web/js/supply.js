const toggleButton = document.querySelector('.nav-toggle');
const menu = document.querySelector('.nav-menu');

toggleButton.addEventListener('click', () => {
  menu.classList.toggle('show');
});

const supplyTableBody = document.getElementById("supplyTableBody");
const addBtn = document.getElementById("addBtn");
const updateBtn = document.getElementById("updateBtn");
const deleteBtn = document.getElementById("deleteBtn");
const selectAllCheckbox = document.getElementById("selectAll");

const modal = document.getElementById("modal");
const modalTitle = document.getElementById("modalTitle");
const modalForm = document.getElementById("modalForm");
const cancelModalBtn = document.getElementById("cancelModalBtn");

const deletePanel = document.getElementById("deletePanel");
const deleteForm = document.getElementById("deleteForm");
const confirmDeleteBtn = document.getElementById("confirmDeleteBtn");
const cancelDeleteBtn = document.getElementById("cancelDeleteBtn");

const shelterSelect = document.getElementById("shelterSelect");

let editingId = null;
let supplies = [];
let shelters = [];

// Fetch shelters from DB

async function populateShelterOptions() {
  const shelterSelect = document.getElementById("shelterSelect");
  shelterSelect.innerHTML = '<option value="" disabled selected>Select Shelter</option>';

  try {
    const response = await fetch("shelterListHandler.jsp");
    shelters = await response.json();

    if (!Array.isArray(shelters)) {
      throw new Error("Shelter list is not an array");
    }

    shelters.forEach(shelter => {
      if (shelter.name && shelter.location) {
        const option = document.createElement("option");
        option.value = shelter.name; // Store shelter name
        option.textContent = `${shelter.name} (${shelter.location})`;
        shelterSelect.appendChild(option);
      }
    });

    console.log("Shelter options loaded:", shelters);

  } catch (err) {
    console.error("Failed to load shelters:", err);
    alert("Error loading shelters from database.");
  }
}



// Fetch supplies from DB
async function loadSupplies() {
  try {
    const response = await fetch("SupplyServlet");
    supplies = await response.json();
    renderTable();
  } catch (err) {
    alert("Failed to load supplies.");
    console.error(err);
  }
}

// Render supplies to table
function renderTable() {
  supplyTableBody.innerHTML = "";
  if (supplies.length === 0) {
    supplyTableBody.innerHTML = `<tr><td colspan="7">No supplies found.</td></tr>`;
    return;
  }

  supplies.forEach((supply, index) => {
    const row = document.createElement("tr");
    row.innerHTML = `
      <td><input type="checkbox" class="rowCheckbox" data-id="${supply.id}"/></td>
      <td>${supply.id}</td>
      <td>${supply.itemName}</td>
      <td>${supply.quantity}</td>
      <td>${supply.unit}</td>
      <td>${supply.status}</td>
      <td>${supply.shelter}</td>
    `;
    supplyTableBody.appendChild(row);
  });

  selectAllCheckbox.checked = false;
}

function openModal(mode, index = null) {
  populateShelterOptions(); 

  modal.style.display = "flex";
  
  if (mode === "add") {
    modalTitle.textContent = "Add Supply";
    modalForm.reset();
    editingId = null;
  } else if (mode === "update") {
    const selected = getSelectedCheckboxes();
    if (selected.length !== 1) {
      alert("Please select exactly one item to update.");
      closeModal();
      return;
    }
    const supply = supplies.find(s => s.id == selected[0]);
    if (!supply) return;

    modalTitle.textContent = "Update Supply";
    document.getElementById("itemName").value = supply.name;
    document.getElementById("quantity").value = supply.quantity;
    document.getElementById("unit").value = supply.unit;
    document.getElementById("status").value = supply.status;
    document.getElementById("shelterSelect").value = supply.shelter;
    editingId = supply.id;
  }
}

function closeModal() {
  modal.style.display = "none";
  modalForm.reset();
}

function getSelectedCheckboxes() {
  return Array.from(document.querySelectorAll(".rowCheckbox:checked"))
              .map(cb => cb.dataset.id);
}

modalForm.addEventListener("submit", async (e) => {
  e.preventDefault();

  const name = document.getElementById("itemName").value.trim();
  const quantity = document.getElementById("quantity").value;
  const unit = document.getElementById("unit").value.trim();
  const status = document.getElementById("status").value;
  const shelter = document.getElementById("shelterSelect").value;

  const formData = new URLSearchParams();
  formData.append("itemName", name);
  formData.append("quantity", quantity);
  formData.append("unit", unit);
  formData.append("status", status);
  formData.append("shelter", shelter);

  if (editingId) {
    formData.append("action", "update");
    formData.append("id", editingId);
  } else {
    formData.append("action", "add");
  }

  try {
    const response = await fetch("SupplyServlet", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: formData.toString()
    });

    const result = await response.text();
    if (result.includes("success")) {
      alert("Saved!");
      closeModal();
      await loadSupplies();
    } else {
      alert("Error: " + result);
    }
  } catch (err) {
    alert("Submission failed.");
    console.error(err);
  }
});

async function deleteSupplies() {
  const selected = getSelectedCheckboxes();
  if (selected.length === 0) return alert("Select at least one supply to delete.");

  if (!confirm("Delete selected supplies?")) return;

  for (const id of selected) {
    await fetch("SupplyServlet", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: `action=delete&id=${id}`
    });
  }

  alert("Deleted!");
  await loadSupplies();
}

addBtn.addEventListener("click", () => openModal("add"));
updateBtn.addEventListener("click", () => openModal("update"));
deleteBtn.addEventListener("click", deleteSupplies);
cancelModalBtn.addEventListener("click", closeModal);

selectAllCheckbox.addEventListener("change", () => {
  const checked = selectAllCheckbox.checked;
  document.querySelectorAll(".rowCheckbox").forEach(cb => cb.checked = checked);
});

supplyTableBody.addEventListener("change", (e) => {
  if (e.target.classList.contains("rowCheckbox") && !e.target.checked) {
    selectAllCheckbox.checked = false;
  }
});

populateShelterOptions();
loadSupplies();
