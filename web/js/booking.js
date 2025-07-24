const toggleButton = document.querySelector('.nav-toggle');
const menu = document.querySelector('.nav-menu');

toggleButton.addEventListener('click', () => {
  menu.classList.toggle('show');
});

const bookingForm = document.getElementById("bookingForm");
const shelterSelect = document.getElementById("shelter");
const bookingTableBody = document.getElementById("bookingTableBody");

let shelters = [];
let bookings = [];

// Populate shelters from DB
async function populateShelters() {
  shelterSelect.innerHTML = '<option value="" disabled selected>Select Shelter</option>';
  try {
    const response = await fetch("shelterListHandler.jsp");
    shelters = await response.json();

    shelters.forEach(shelter => {
      const option = document.createElement("option");
      option.value = shelter.id;
      option.textContent = `${shelter.name} (${shelter.location})`;
      shelterSelect.appendChild(option);
    });
  } catch (err) {
    alert("Failed to load shelters.");
    console.error(err);
  }
}

// Fetch bookings from DB
async function loadBookings() {
  try {
    const response = await fetch("BookingServlet");
    bookings = await response.json();
    renderBookings();
  } catch (err) {
    alert("Failed to load bookings.");
    console.error(err);
  }
}

// Render bookings table
function renderBookings() {
  bookingTableBody.innerHTML = "";

  if (!bookings || bookings.length === 0) {
    bookingTableBody.innerHTML = `<tr><td colspan="9">No bookings found.</td></tr>`;
    return;
  }

  bookings.forEach(b => {
    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td>${b.id}</td>
      <td>${b.name}</td>
      <td>${b.email}</td>
      <td>${b.shelterName}</td>
      <td>${b.startDate}</td>
      <td>${b.endDate}</td>
      <td>${b.people}</td>
      <td class="${b.status === 'Active' ? 'status-active' : 'status-cancelled'}">${b.status}</td>
      <td>${b.status === 'Active' ? `<button onclick="cancelBooking(${b.id})">Cancel</button>` : '-'}</td>
    `;
    bookingTableBody.appendChild(tr);
  });
}

// Submit booking to DB
bookingForm.addEventListener("submit", async (e) => {
  e.preventDefault();

  const name = document.getElementById("name").value.trim();
  const email = document.getElementById("email").value.trim();
  const shelterId = document.getElementById("shelter").value;
  const startDate = document.getElementById("startDate").value;
  const endDate = document.getElementById("endDate").value;
  const people = document.getElementById("people").value;

  if (new Date(startDate) > new Date(endDate)) {
    alert("End date must be after start date.");
    return;
  }

  const formData = `action=create&name=${encodeURIComponent(name)}&email=${encodeURIComponent(email)}&shelterId=${shelterId}&startDate=${startDate}&endDate=${endDate}&people=${people}`;


  try {
    const response = await fetch("BookingServlet", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: formData
    });

    const result = await response.text();
    if (result.includes("success")) {
      alert("Booking created!");
      bookingForm.reset();
      await loadBookings();
      document.querySelector('.tab[data-tab="view"]').click(); // switch tab
    } else {
      alert("Booking failed: " + result);
    }
  } catch (err) {
    alert("Error sending booking.");
    console.error(err);
  }
});

// Cancel booking
async function cancelBooking(id) {
  if (!confirm("Cancel booking ID #" + id + "?")) return;

  try {
    const response = await fetch("BookingServlet", {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body: `action=cancel&id=${id}`
    });

    const result = await response.text();
    if (result.includes("success")) {
      await loadBookings();
    } else {
      alert("Failed to cancel: " + result);
    }
  } catch (err) {
    alert("Error cancelling booking.");
    console.error(err);
  }
}

window.cancelBooking = cancelBooking;

// Tab switching
document.querySelectorAll(".tab").forEach(tab => {
  tab.addEventListener("click", () => {
    document.querySelectorAll(".tab").forEach(t => t.classList.remove("active"));
    tab.classList.add("active");

    document.querySelectorAll(".tab-content").forEach(content => content.style.display = "none");
    document.getElementById(tab.dataset.tab).style.display = "block";
  });
});

// Init
populateShelters();
loadBookings();
