<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*"%>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>

<%
String productId = request.getParameter("productId");
String userName = (String) session.getAttribute("userName");
applicationDBManager dbm = new applicationDBManager();

if (request.getParameter("placeBid") != null) {
    String amount = request.getParameter("amount");
    dbm.placeBid(Integer.parseInt(productId), userName, amount);
    out.println("<p>Bid placed successfully!</p>");
    out.println("<a href='displayItem.jsp?productId=" + productId + "'>Back</a>");
} else {
%>
<form method="post" action="bidProduct.jsp?productId=<%=productId%>">
    Amount: <input type="text" name="amount" required>
    <input type="submit" name="placeBid" value="Bid">
</form>
<%
}
dbm.close();
%>
