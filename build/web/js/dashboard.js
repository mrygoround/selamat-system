const toggleButton = document.querySelector('.nav-toggle');
const menu = document.querySelector('.nav-menu');

toggleButton.addEventListener('click', () => {
  menu.classList.toggle('show');
});

async function loadShelters() {
  try {
    const response = await fetch("shelterListHandler.jsp");
    const shelters = await response.json();

    const tableBody = document.getElementById('tableBody');
    tableBody.innerHTML = '';

    if (!Array.isArray(shelters) || shelters.length === 0) {
      tableBody.innerHTML = '<tr><td colspan="5">No shelter data found.</td></tr>';
      return;
    }

    shelters.forEach((shelter, i) => {
      const row = document.createElement('tr');
      row.innerHTML = `
        <td>${i + 1}</td>
        <td>${shelter.name}</td>
        <td>${shelter.location}</td>
        <td>${shelter.capacity}</td>
        <td>${shelter.status}</td>
      `;
      tableBody.appendChild(row);
    });

  } catch (err) {
    console.error("Error fetching shelter data:", err);
    document.getElementById('tableBody').innerHTML =
      '<tr><td colspan="5">Error loading shelter data.</td></tr>';
  }
}

// Call on load
loadShelters();
