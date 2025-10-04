<%/******
 This page create a connection to the Products database, and list all products in the table products using the 
//ut.JAR.CPEN410.ApplicationProductManager class.**/
%>

<%//Import the ut.JAR.CPEN410 package for accessing the database %>
<%@ page import="ut.JAR.CPEN410.*"%>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>


<html>
	<head>
		<title>MiniEbay - Product Listing</title>
	</head>
	<body>
	<h1>Here are the listing of the products</h1>
	<table border=1>
	<tr><td>Name</td><td>Description</td><td>Bid</td></tr>
	<%
	//Try to connect the database using the applicationProductManager class
	try{
			//Create the ProductsMnger object
			applicationProductManager ProductsMnger = new applicationProductManager();
			System.out.println("Connecting...");
			//System.out.println(appDBMnger.toString());
			
			//Call the listAllProducts method. This method returns a ResultSet containing all the tuples in the table Products
			ResultSet res=ProductsMnger.listAllProducts();
		
		
			int count=0;
			//Iterate over the ResultSet
			while (res.next())
			{
				//Count each retrieved record from the query
				count++;%>
				<tr>
				<%//Print the products name, the description, and the bid%>
				<td><%=res.getString(2)%></td><td><%=res.getString(3)%></td><td><%=res.getString(6)%></td>
				</tr>
				
			<%}
				//Print the number of retrieved records
			%>
		</table>
			Count:  <%=count%>
			
			<%
			//Close the ResultSet
			res.close();
			//Close the connection to the database
			ProductsMnger.close();
			
		} catch(Exception e)
		{%>
			Nothing to show!
			<%e.printStackTrace();
		}%>		
		
	</body>
</html>