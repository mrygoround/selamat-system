<%
  session.invalidate(); // clear session
  response.sendRedirect("login.jsp"); // redirect to login page
%>