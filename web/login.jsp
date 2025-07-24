<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Login & Register</title>
  <link rel="stylesheet" href="css/login.css" />
</head>
<body>
  <div class="container" id="login-container">
    <h2>Login</h2>
    <form method="post" action="loginHandler.jsp">
    <input type="text" name="username" placeholder="Username or Email" required>
    <input type="password" name="password" placeholder="Password" required>
    <button type="submit">Login</button>
    </form>
    <div class="toggle">
      <p>Not registered? <a href="register.jsp">Register</a></p>
    </div>
  </div>


  <script src="js/login.js"></script>
</body>
</html>
