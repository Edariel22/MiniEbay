<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Place a Bid</title>
	</head>
	<body>

<%
try {

	// check if user is logged in
	if (session.getAttribute("userName") == null || session.getAttribute("currentPage") == null) {
		session.setAttribute("currentPage", null);
		session.setAttribute("userName", null);
		response.sendRedirect("loginHashing.html");
	} else {
		String productId = request.getParameter("productId");
		String currentPage = "bidProduct.jsp";
		String userName = session.getAttribute("userName").toString();
		String previousPage = session.getAttribute("currentPage").toString();
		session.setAttribute("currentPage", currentPage);

		// connect db
		applicationDBAuthenticationGoodComplete dba = new applicationDBAuthenticationGoodComplete();
		applicationDBManager dbm = new applicationDBManager();

		// verify user can be here
		ResultSet rsUser = dba.verifyUser(userName, currentPage, previousPage);

		if (rsUser.next()) {

			session.setAttribute("userName", userName);

			// get product info
			ResultSet rs = dbm.getProductById(Integer.parseInt(productId));
			double startBid = 0;
			String productName = "";
			if (rs.next()) {
				startBid = rs.getDouble("start_bid");
				productName = rs.getString("name");
			}
			rs.close();

			// get highest bid
			ResultSet rsHigh = dbm.getHighestBid(Integer.parseInt(productId));
			double high = 0;
			if (rsHigh.next() && rsHigh.getString("highest_bid") != null) {
				high = rsHigh.getDouble("highest_bid");
			}
			rsHigh.close();

			// if bid button pressed
			if (request.getParameter("placeBid") != null) {
				double amount = Double.parseDouble(request.getParameter("amount"));

				if (amount <= startBid || amount <= high) {
					out.println("Bid too low, must be higher than " + Math.max(startBid, high));
				} else {
					dbm.placeBid(Integer.parseInt(productId), userName, "" + amount);
					out.println("Bid placed: $" + amount);
				}

				out.println("<br><a href='displayItem.jsp?productId=" + productId + "'>Back</a>");
			} else {
				// simple form
%>
				<h2>Place a Bid on: <%=productName%></h2>
				Start Bid: $<%=startBid%><br>
				Highest Bid: $<%=high%><br><br>
				<form method="post" action="bidProduct.jsp?productId=<%=productId%>">
					Amount: <input type="text" name="amount">
					<input type="submit" name="placeBid" value="Bid">
				</form>
				<a href="displayItem.jsp?productId=<%=productId%>">Back</a>
<%
			}

			dbm.close();
			dba.close();

		} else {
			session.setAttribute("userName", null);
			response.sendRedirect("loginHashing.html");
		}
	}

} catch (Exception e) {
	e.printStackTrace();
	response.sendRedirect("loginHashing.html");
} finally {
	System.out.println("Finally");
}
%>

	</body>
</html>
