const toggleButton = document.querySelector('.nav-toggle');
    const menu = document.querySelector('.nav-menu');

    toggleButton.addEventListener('click', () => {
      menu.classList.toggle('show');
    });

    const shelters = [
      { name: "Shelter A", location: "Area 1", capacity: 100, status: "Available" },
      { name: "Shelter B", location: "Area 2", capacity: 80, status: "Full" },
      { name: "Shelter C", location: "Area 3", capacity: 120, status: "Available" },
      { name: "Shelter D", location: "Area 4", capacity: 90, status: "Available" },
      { name: "Shelter E", location: "Area 5", capacity: 70, status: "Under Maintenance" }
    ];

    function renderTable() {
      const tableBody = document.getElementById('tableBody');
      tableBody.innerHTML = '';
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
    }

    renderTable();/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


