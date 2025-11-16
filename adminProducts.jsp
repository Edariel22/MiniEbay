<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Modify Products as an Admin.</title>
	</head>
	<body>

<%
if (session.getAttribute("userName") == null && request.getParameter("userName") != null)
    session.setAttribute("userName", request.getParameter("userName"));
if (session.getAttribute("roleId") == null && request.getParameter("roleId") != null)
    session.setAttribute("roleId", request.getParameter("roleId"));

applicationDBManager dbm = new applicationDBManager();

// Add product
if (request.getParameter("addProduct") != null) {
    String name = request.getParameter("name");
    String deptId = request.getParameter("deptId");
    String startBid = request.getParameter("startBid");
    String dueDate = request.getParameter("dueDate");
    dbm.addProduct(name, deptId, startBid, dueDate);
}

// Remove product
if (request.getParameter("removeProduct") != null) {
    int productId = Integer.parseInt(request.getParameter("removeProductId"));
    dbm.removeProduct(productId);
}

// List products
ResultSet rs = dbm.listProducts();
%>

<h2>Admin - Product Management</h2>

<table border="1">
<tr><td>ID</td><td>Name</td><td>Dept ID</td><td>Start Bid</td><td>Due Date</td></tr>
<%
while(rs.next()){
	out.print("<tr>");
	out.print("<td>"+rs.getString("product_id")+"</td>");
	out.print("<td>"+rs.getString("name")+"</td>");
	out.print("<td>"+rs.getString("dept_id")+"</td>");
	out.print("<td>"+rs.getString("start_bid")+"</td>");
	out.print("<td>"+rs.getString("due_date")+"</td>");
	out.print("</tr>");
}
rs.close();
dbm.close();
%>
</table>

<h3>Add Product</h3>
<form method="POST" action="adminProducts.jsp">
Name: <input type="text" name="name"><br>
Dept ID: <input type="text" name="deptId"><br>
Start Bid: <input type="text" name="startBid"><br>
Due Date (YYYY-MM-DD HH:MM:SS): <input type="text" name="dueDate"><br>
<input type="submit" name="addProduct" value="Add">
</form>

<h3>Remove Product</h3>
<form method="POST" action="adminProducts.jsp">
Product ID: <input type="text" name="removeProductId"><br>
<input type="submit" name="removeProduct" value="Remove">
</form>
<a href="welcomeMenu.jsp">Return to Main Menu</a>
</body>
</html>
