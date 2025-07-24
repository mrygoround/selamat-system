<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Register</title>
  <link rel="stylesheet" href="css/login.css" />
</head>
<body>
  <div class="container">
    <h2>Register</h2>
    <form method="post" action="registerHandler.jsp">
      <input type="text" name="username" placeholder="Username" required>
      <input type="email" name="email" placeholder="Email" required>
      <input type="password" name="password" placeholder="Password" required>
      <input type="password" name="confirm" placeholder="Confirm Password" required>
      <button type="submit">Register</button>
    </form>
    <div class="toggle">
      <p>Already have an account? <a href="login.jsp">Login</a></p>
    </div>
  </div>
</body>
</html>
