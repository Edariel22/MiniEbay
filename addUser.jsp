<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*"%>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Add a new User.</title>
	</head>
	<body>

<%
	//Retrieve variables
	String userName = request.getParameter("userName");
	String userPass = request.getParameter("userPass");
	String completeName = request.getParameter("completeName");
	String telephone = request.getParameter("telephone");	


	//Try to connect to the database
	try{
		//Create the dba object
		applicationDBAuthenticationGoodComplete dba = new applicationDBAuthenticationGoodComplete();
		System.out.println("Connecting...");
		System.out.println(dba.toString());

		//first, check if the user filled all information before trying to add them
		if (userName ==  null || userName == "" || userPass=="" || completeName == "" || telephone == ""){
			response.sendRedirect("addNewUser.html"); // Send user back
			dba.close();
		}
			
		//Call Add the user to the tables (as boolean so they can return false just in case they fail)
		boolean res=dba.addUser(userName, completeName, userPass, telephone);
		boolean setUserRole = dba.setUserRole(userName);%>

		<%//Verify if the user has been authenticated
		if (res){%>
			User succesfully added 
			<%
			//Create the current page attribute
            session.setAttribute("currentPage", "addUser.jsp");

            //Create a session variable
            if (session.getAttribute("userName")==null ){
                //create the session variable
                session.setAttribute("userName", userName);
            } else{
                //Update the session variable
                session.setAttribute("userName", userName);
            }

            //redirect to the welcome page
            response.sendRedirect("welcomeMenu.jsp"); %>

		<%}else{
			//Close any session associated with the user
			session.setAttribute("userName", null);
			%>
			Cannot be added <br>
		<%}
				
			//Close the connection to the database
			dba.close();
			
	} catch(Exception e){
		%>Nothing to show!<%
		e.printStackTrace();
	}finally{
		System.out.println("Finally");
	}
	%>//sessionName=<%=session.getAttribute("userName")%>
	</body>
</html>
