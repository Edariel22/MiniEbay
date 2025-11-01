
<%//Import the ut.JAR.miniebay package for accessing the database %>

<%@ page import="ut.JAR.miniebay.applicationProductManager"%>
<%//Import the java.sql package to use the ResultSet class %>

<%@ page import="java.sql.ResultSet"%>


<html>
	<head>
		<title>Mini Ebay - Product Listing</title>
	</head>
	<body>
	<h1>Here are the listing of the products 2</h1>
	<table border=1>
	<tr><td>Name</td><td>Description</td><td>Department</td><td>Bid</td><td>Due Date</td><td>Picture</td></tr>
	<%
	//Try to connect the database using the applicationProductManager class
	try{
			//Create the ProdMng object
			applicationProductManager ProdMng = new applicationProductManager();
			System.out.println("Connecting...");
			//System.out.println(appDBMnger.toString());
			
			//Call the listAllProducts method. This method returns a ResultSet containing all the tuples in the table Products
			ResultSet resProd=ProdMng.listAllProducts();
		
		
			int count=0;
			//Iterate over the ResultSet
			while (resProd.next())
			{
				String deptName = ProdMng.getDepartmentName(resProd.getInt(4));
				//Count each retrieved record from the query
				count++;%>
				<tr>
				<td><%=resProd.getString("name")%></td> <!-- Product Name -->
				<td><%=resProd.getString("description")%></td> <!-- Description -->
				<td><%=deptName%></td> <!-- Department Name -->
				<td><%=resProd.getString("start_bid")%></td> <!-- Start Bid -->
				<td><%=resProd.getString("due_date")%></td> <!-- Due Date -->
				<td><img src="/MiniEbay<%=resProd.getString(7)%>" width="100" height="100"></td> <!-- Picture -->
				</tr>

				
			<%}
				//Print the number of retrieved records
			%>
		</table>
			Count:  <%=count%>
			
			<%
			//Close the ResultSet
			resProd.close();
			//Close the connection to the database
			ProdMng.close();
			
		} catch(Exception e)
		{%>
			Nothing to show!
			<%e.printStackTrace();
		}%>		
		
	</body>
</html>