<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Sistem SELAMAT - Tempahan Shelter</title>
  <link rel="stylesheet" href="css/index.css" />
  
</head>
<body>
  <nav>
    <div class="nav-container">
      <a href="index.jsp" class="nav-logo">SELAMAT</a>
      <button class="nav-toggle" aria-label="Toggle menu">&#9776;</button>
      <ul class="nav-menu">
        <li><a href="login.jsp">Login</a></li>
      </ul>
    </div>
  </nav>

  <header>
    <h1>SELAMAT</h1>
    <p>Platform Tempahan Shelter Kecemasan yang Selamat, Mudah & Cekap</p>
  </header>

  <main>
    <section>
      <h2>Senarai Shelter Tersedia</h2>
      <p>Sistem ini membolehkan anda menyemak dan membuat tempahan untuk shelter kecemasan di seluruh negara. Maklumat dikemaskini secara langsung bagi memastikan anda mendapat info yang tepat dan terkini.</p>
      <table id="shelterTable">
        <thead>
          <tr>
            <th>ID</th>
            <th>Nama</th>
            <th>Lokasi</th>
            <th>Kapasiti</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody id="tableBody"></tbody>
      </table>
    </section>
  </main>

  <script src="js/index.js"></script>
</body>
</html>
