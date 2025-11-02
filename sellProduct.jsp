<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*"%>
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
    String dept = request.getParameter("dept_name");  // fixed: matches form
    String startBid = request.getParameter("startBid");
    String dueDate = request.getParameter("dueDate");
    String picture = request.getParameter("picture_path"); // fixed: input name consistency
    picture = "/images/" + picture;

    dbm.addProduct(name, desc, dept, startBid, dueDate, picture, userName);
    out.println("<p>Product listed successfully!</p>");
}
%>

<h2>Sell a Product</h2>

<form id="form_1" action="sellProduct.jsp" method="POST"><br>
    <tr>
        Product Name: <input type="text" name="name" required><br>
    </tr>
    <tr>
        Description: <input type="text" name="description" required><br>
    </tr>
    <tr>
        Starting Bid $: <input type="text" name="startBid" required><br>
    </tr>
    <tr>
        Due Date (YYYY-MM-DD HH:MM:SS): <input type="text" name="dueDate" required><br>
    </tr>
    <tr>
        Picture: <input type="text" name="picture_path" placeholder="product.jpg" required><br>
    </tr>

    <%
    // Get all departments from database
    ResultSet rsDept = dbm.listAllDepartment();
    %> 
    <tr>
        <td>Department:</td>
        <td>
            <select id="dept_name" name="dept_name">
                <%
                while (rsDept.next()) {
                %>
                    <option value="<%=rsDept.getString("dept_id")%>"><%=rsDept.getString("name")%></option>
                <%
                }
                rsDept.close();
                %>
            </select>
        </td>
    </tr>

    </table>
    <input type="submit" name="addProduct" id="Submit" value="Submit" />
    <input type="reset" id="Submit" value="Reset" />
</form>

<form action="welcomeMenu.jsp" method="POST">
    <button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
</form>

<%
dbm.close();
%>
<br><a href="welcomeMenu.jsp">← Back to Main Menu</a>

</body>
</html>
