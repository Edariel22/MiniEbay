
/********
CPEN 410 Mobile, Web, and Internet programming

This servlet perform a dummy authentication process
if the user is authenticated, it sends a json objects containing: id, name, userName and phone number
Required values:
	userName: user
	passWord: pass



******************/

// Import required java libraries
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import ut.JAR.miniebay.*;


// Extend HttpServlet class
public class authenticateApplicationMobile extends HttpServlet {
 
   private String message;
   private String title;

   public void init() throws ServletException {
      // Do required initialization
      message = "Hello World";
	  title = "my first servlet";
   }


/***
	doGet method: it is executed when the GET method is used for the http request
**/

   public void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
     
	 
      // Set response content type
      response.setContentType("text/html");

      // Actual logic goes here.
      PrintWriter out = response.getWriter();
      
	  // Send the response
	  out.println("This servlet does not support authentication via GET method!");
	 }
/*****

	doPost method: this method is executed when the POST method is used for the http request

**/
	public void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
     
	 //Retreive the http request parameters
	 String userName=request.getParameter("user");
	 String passwd = request.getParameter("pass");
	 
      // Set response content type
      response.setContentType("text/html");

      // Actual logic goes here.
      PrintWriter out = response.getWriter();
     
      //Perform the actual authentication process
	  String msg = doAuthentication(userName, passwd);
	  
	  //Send the final response to the requester
	  out.println(msg);
	  System.out.println(msg);
	     }

	/****
		This method perform a dummy authentication process
	***/
   
   
   public String doAuthentication(String userName, String passwd)
   {
		
		String msg="not";
		
		
		try{
			applicationDBAuthenticationGoodComplete dba = new applicationDBAuthenticationGoodComplete();
			ResultSet res = dba.authenticate(userName, passwd);
			if (res.next()){
			  //You got authenticated
			  //then, generate the JSON object
			  msg="{\"userName\"=\"" + res.getString(1) + "\", \n";
			  msg+="\"hashing\"=\""+ res.getString(2) +"\", \n";
			  msg+="\"name\"=\""+ res.getString(3) +"\", \n";
			  msg+="\"telephone\"=\""+ res.getString(4) +"\" \n}";
			}
		  }
		catch(Exception e)
		{}
		finally{
		//Return the actual message
			return msg;
		}
   }


   public void destroy() {
      // do nothing.
   }
}
