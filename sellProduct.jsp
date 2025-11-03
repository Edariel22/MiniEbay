<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%@ page import="java.sql.*" %>

<html>
<head>
	<title>Sell a Product</title>
</head>
<body>

<%
try {
	// check login, redirect if user not logged in
	String userName = (String) session.getAttribute("userName");
	if (userName == null) {
		response.sendRedirect("loginHashing.html");
		return;
	}

	// connect to DB
	applicationDBManager dbm = new applicationDBManager();

	// if user pressed submit button
	if (request.getParameter("addProduct") != null) {

		// grab all input values
		String name = request.getParameter("name");
		String desc = request.getParameter("description");
		String dept = request.getParameter("dept_name");
		String startBid = request.getParameter("startBid");
		String dueDate = request.getParameter("dueDate");
		String picture = request.getParameter("picture_path");

		// prepend images folder
		picture = "/images/" + picture;

		// basic validation to make sure nothing empty
		if (name.isEmpty() || desc.isEmpty() || startBid.isEmpty() || dueDate.isEmpty() || picture.isEmpty()) {
			out.println("<p>Please fill out all fields.</p>");
		} else {
			// call DB method to add product
			dbm.addProduct(name, desc, dept, startBid, dueDate, picture, userName);
			out.println("<p>Product listed successfully!</p>");
		}
	}

	// get departments for dropdown
	ResultSet rsDept = dbm.listAllDepartment();
%>

<h2>Sell a Product</h2>

<form method="POST" action="sellProduct.jsp">
	Name: <input type="text" name="name" required><br>
	Description: <input type="text" name="description" required><br>
	Starting Bid $: <input type="text" name="startBid" required><br>
	Due Date (YYYY-MM-DD HH:MM:SS): <input type="text" name="dueDate" required><br>
	Picture File Name: <input type="text" name="picture_path" placeholder="keyboard.jpg" required><br>

	Department:
	<select name="dept_name">
		<%
		while (rsDept.next()) {
		%>
			<option value="<%=rsDept.getString("dept_id")%>"><%=rsDept.getString("name")%></option>
		<%
		}
		rsDept.close();
		%>
	</select><br><br>

	<input type="submit" name="addProduct" value="Submit">
	<input type="reset" value="Reset">
</form>

<form action="welcomeMenu.jsp" method="POST">
	<button type="submit">Back to main page</button>
</form>

<%
	dbm.close();
} catch(Exception e) {
	e.printStackTrace();
	response.sendRedirect("loginHashing.html");
} finally {
	System.out.println("Finally");
}
%>

</body>
</html>
