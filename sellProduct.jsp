<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*"%>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>

<html>
<head><title>Sell a Product</title></head>
<body>

<%
String userName = (String) session.getAttribute("userName");
if (userName == null) {
    response.sendRedirect("loginHashing.html");
    return;
}

applicationDBManager dbm = new applicationDBManager();

if (request.getParameter("addProduct") != null) {
    String name = request.getParameter("name");
    String desc = request.getParameter("description");
    String dept = request.getParameter("dept_id");
    String startBid = request.getParameter("startBid");
    String dueDate = request.getParameter("dueDate");
    String picture = request.getParameter("picture_path");
    picture = "/images/" + picture;

    dbm.addProduct(name, desc, dept, startBid, dueDate, picture, userName);
    out.println("<p>Product listed successfully!</p>");
}
%>

<h2>Sell a Product</h2>
<form method="post" action="sellProduct.jsp">
Name: <input type="text" name="name" required><br>
Description: <input type="text" name="description" required><br>
Department ID: <input type="text" name="dept_id" required><br>
Starting Bid: <input type="text" name="startBid" required><br>
Due Date (YYYY-MM-DD HH:MM:SS): <input type="text" name="dueDate" required><br>
Picture Name: <input type="text" name="picture_path" placeholder="product.jpg" required><br>
<input type="submit" name="addProduct" value="List Product">
</form>

<br><a href="welcomeMenu.jsp">← Back to Main Menu</a>

<%
dbm.close();
%>

</body>
</html>
