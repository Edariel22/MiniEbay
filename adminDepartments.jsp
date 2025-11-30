<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Modify Departments as an Admin.</title>
	</head>
	<body>

<%
if (session.getAttribute("userName") == null && request.getParameter("userName") != null)
    session.setAttribute("userName", request.getParameter("userName"));

if (session.getAttribute("roleId") == null && request.getParameter("roleId") != null)
    session.setAttribute("roleId", request.getParameter("roleId"));


session.setAttribute("previousPage", "welcomeMenu.jsp");
session.setAttribute("currentPage", "adminDepartments.jsp");

try {

    //Authenticate if the user is logged in, if not redirect the user to login hashing
    if (session.getAttribute("userName") == null) {
        response.sendRedirect("loginHashing.html");
    } else {
        String currentPage = "adminDepartments.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("previousPage").toString();

        //Create dba object
        applicationDBAuthenticationGoodComplete dba = new applicationDBAuthenticationGoodComplete();
        System.out.println("Connecting...");
        System.out.println(dba.toString());

        //Create dbm object
        applicationDBManager dbm = new applicationDBManager();
        System.out.println("Connecting...");
        System.out.println(dbm.toString());

        //Call the verifyUser method to authenticate the user
        ResultSet rsUser = dba.verifyUser(userName, currentPage, previousPage);

        // Verify if the user has been authenticated
        if (rsUser.next()) {
            session.setAttribute("currentPage", currentPage);

            if (request.getParameter("addDept") != null) {
                String name = request.getParameter("name");
                String building = request.getParameter("building");
                dbm.addDepartment(name, building);
            }

            if (request.getParameter("modifyDept") != null) {
               int deptId = Integer.parseInt(request.getParameter("removeDeptId"));
               String name = request.getParameter("name");
               String building = request.getParameter("building");
               boolean res = dbm.updateDepartmentAdmin(deptId, name, building);
               if (res) {
                   out.println("<p>Department modified successfully.</p>");
               } else {
                   out.println("<p>Failed to modify department.</p>");
               }
            }

            if (request.getParameter("removeDept") != null) {
               int deptId = Integer.parseInt(request.getParameter("removeDeptId"));
               dbm.removeDepartment(deptId);
            }

            ResultSet rs = dbm.listAllDepartment();
%>

<h2>Admin - Department Management</h2>

<table border="1">
<tr><td>ID</td><td>Name</td><td>Building</td></tr>
<%
while(rs.next()){
	out.print("<tr>");
	out.print("<td>"+rs.getString(1)+"</td>"); 
	out.print("<td>"+rs.getString(2)+"</td>");
	out.print("<td>"+rs.getString(3)+"</td>");
	out.print("</tr>");
}
rs.close();
// Close the connection to the database
dba.close();
dbm.close();
        }
    }

} catch (Exception e) {
    //If an exception occurs, print the stack trace
    e.printStackTrace();
    response.sendRedirect("loginHashing.html");
} finally {
    System.out.println("Finallly");
}
%>
</table>

<h3>Add Department</h3>
<form method="post" action="adminDepartments.jsp">
Name: <input type="text" name="name"><br>
Building: <input type="text" name="building"><br>
<input type="submit" name="addDept" value="Add">
</form>

<h3>Modify Department</h3>
<form method="post" action="adminDepartments.jsp">
ID: <input type="text" name="removeDeptId"><br>
Name: <input type="text" name="name"><br>
Building: <input type="text" name="building"><br>
<input type="submit" name="modifyDept" value="Modify">
</form>

<h3>Remove Department</h3>
<form method="post" action="adminDepartments.jsp">
ID: <input type="text" name="removeDeptId"><br>
<input type="submit" name="removeDept" value="Remove">
</form>
<a href="welcomeMenu.jsp">Return to Main Menu</a>
</body>
</html>
