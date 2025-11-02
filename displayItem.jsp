<%@ page import="java.sql.*" %>
<%@ page import="ut.JAR.miniebay.*" %>

<html>
<head><title>Product Details</title></head>
<body>

<%
String productId = request.getParameter("productId");
if (productId == null || productId.isEmpty()) {
    out.println("<h3>No product selected.</h3>");
} else {
    applicationDBManager dbm = new applicationDBManager();
    ResultSet rs = dbm.getProductById(Integer.parseInt(productId));

    if (rs.next()) {
%>
        <h2><%=rs.getString("name")%></h2>
        <p><b>Description:</b> <%=rs.getString("description")%></p>
        <p><b>Department:</b> <%=rs.getString("dept_id")%></p>
        <p><b>Start Bid:</b> $<%=rs.getString("start_bid")%></p>
        <p><b>Due Date:</b> <%=rs.getString("due_date")%></p>
        <%
        ResultSet highest = dbm.getHighestBid(Integer.parseInt(productId));
        if (highest.next() && highest.getString("highest_bid") != null) {
            out.println("<p><b>Current Highest Bid:</b> $" + highest.getString("highest_bid") + "</p>");
        } else {
            out.println("<p><b>No bids yet.</b></p>");
        }
        highest.close();
        %>

        <a href="bidProduct.jsp?productId=<%=productId%>">Place a Bid</a>

        <img src="/MiniEbay<%=rs.getString("picture_path")%>" width="200" height="200">
<%
    } else {
        out.println("<h3>Product not found.</h3>");
    }

    rs.close();
    dbm.close();
}
%>

<br><a href="findProduct.jsp">← Back to Product Search</a>
</body>
</html>
