<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.MiniEbay.*"%>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Add an Admin!</title>
	</head>
	<body>
    <%
//Try to connect the database using the applicationDBManager class
try {
    // Check the authentication process
    if (session.getAttribute("userName") == null || session.getAttribute("currentPage") == null) {
        session.setAttribute("currentPage", null);
        session.setAttribute("userName", null);
        response.sendRedirect("../html/loginHashing.html");
    }else{

        String currentPage = "../jsp/addAdmin.jsp";
        String userName = session.getAttribute("userName").toString();
        String previousPage = session.getAttribute("currentPage").toString();

        //Retrieve variables
        String userNameAdmin = request.getParameter("userName");
        String userPass = request.getParameter("userPass");
        String completeName = request.getParameter("completeName");
        String telephone = request.getParameter("telephone");    

        //Create the appDBAuth object
        applicationDBAuthenticationGoodComplete appDBAuth = new applicationDBAuthenticationGoodComplete();
        System.out.println("Connecting...");
        System.out.println(appDBAuth.toString());

        //Call the verifyUser method.
		ResultSet resUser=appDBAuth.verifyUser(userName, currentPage, previousPage);
			
		//Verify if the user has been authenticated
		if (resUser.next()){
			String userActualName=resUser.getString(3);
					
			//Create the current page attribute
			session.setAttribute("currentPage", currentPage);
					
			//Create a session variable
			if (session.getAttribute("userName")==null ){
				//create the session variable
				session.setAttribute("userName", userName);
			}else{
				//Update the session variable
				session.setAttribute("userName", userName);
			}

            //Call the addUser method to add a new user
			boolean resAddUser = appDBAuth.addUser(userNameAdmin, completeName, userPass, telephone);
//			boolean resRoleUser = appDBAuth.setAdminRole(userNameAdmin);
            
            if (resAddUser) {
                %>
				Admin has been successfully added!
				<form action="../jsp/welcomeMenu.jsp" method="GET">
					<button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
				</form> 

				<form action="../jsp/newAdmin.jsp" method="GET">
					<button type="submit" name="newAdmin" value="newAdmin">New Admin</button>
				</form>
                <%
            } else {
                %>
                Admin cannot be added <br>
				<form action="../jsp/welcomeMenu.jsp" method="GET">
					<button type="submit" name="welcomeMenu" value="welcomeMenu">Back to main page</button>
				</form>

				<form action="../jsp/modifyUser.jsp" method="GET">
					<button type="submit" name="modifyUser" value="modifyUser">Modify User</button>
				</form>
                <%
            }
        }else{
            // Close any session associated with the user
            session.setAttribute("userName", null);

            // Return to the login page
            response.sendRedirect("../html/loginHashing.html");
        }
        // Close the connection to the database
        appDBAuth.close();
    }
}catch(Exception e){

    // Print error message if an exception occurs
    e.printStackTrace();
    out.println("Exception occurred: " + e.getMessage());

}finally{
    System.out.println("Finally");
}
    %>     
    </body>
</html>
