<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.MiniEbay.*" %>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Add a new User!</title>
	</head>
	<body>

<%
	//Retrieve variables
	String userName = request.getParameter("userName");
	String userPass = request.getParameter("userPass");
	String completeName = request.getParameter("completeName");
	String telephone = request.getParameter("telephone");

	//Try to connect the database using the applicationDBManager class
	try{

		/*//Check the authentication process
		if (session.getAttribute("userName")==null || session.getAttribute("currentPage")==null) {
			session.setAttribute("currentPage", null);
			session.setAttribute("userName", null);
			response.sendRedirect("../html/addNewUser.html");
		}*/

			//Create the appDBMnger object
			applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
			System.out.println("Connecting...");
			System.out.println(appDBAuth.toString());
			
			/*verify if the user entered something in before accessing the jsp (and if they have not, 
			send them back to the adding user page html)*/
			if (userName ==  null || userName == "" || userPass=="" || completeName == "" || telephone == ""){
			response.sendRedirect("../html/addNewUser.html");
			appDBAuth.close();
			}

			//Call the listAllDepartment method. This method returns a ResultSet containing all the tuples in the table Department
			boolean resUser=appDBAuth.addUser(userName, completeName, userPass, telephone);
//			boolean resRoleUser = appDBAuth.setUserRole(userName);
			%>
		
			
			
			<%//Verify if the user has been authenticated

			if (resUser){%>
			User has been succesfully added!
			<%
			//Set the current page attribute
            session.setAttribute("currentPage", "../jsp/addUser.jsp");

            //Create a session variable
            if (session.getAttribute("userName")==null ){
                //Create the session variable
                session.setAttribute("userName", userName);
	
            } else{

                //Update the session variable
                session.setAttribute("userName", userName);
            }

            //Redirect the User to the welcome page.
            response.sendRedirect("../jsp/welcomeMenu.jsp"); %>


			<%}else{
				//Close any session associated with the user and send them back
				//to the adding user page html
				session.setAttribute("userName", null);
				%>
				Cannot be added...	
				response.sendRedirect("../html/addNewUser.html");				
			<%}
				
				//Close the connection to the database
				appDBAuth.close();
			
			} catch(Exception e)
			{%>
				Nothing to show!
				<%e.printStackTrace();
			}finally{
				System.out.println("Finally");
			}
			%>		
		sessionName=<%=session.getAttribute("userName")%>
		
		
	</body>
</html>
