/********
CPEN 410 Mobile, Web, and Internet programming

This servlet perform a bid placement process
if the bid is placed, it sends a message containing: ok
Required values:
	userName: user
	productId: product id
	bid: bid



******************/

// Import required java libraries
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.sql.*;
import ut.JAR.miniebay.*;


// Extend HttpServlet class
public class placeBidMobile extends HttpServlet {
 
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
	  out.println("This servlet does not support bidding via GET method!");
	 }
/*****

	doPost method: this method is executed when the POST method is used for the http request

**/
	public void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
     
	 //Retreive the http request parameters
	 String userName = request.getParameter("user");
	 String productId=request.getParameter("productId");
	 String bid = request.getParameter("bid");
	 
      // Set response content type
      response.setContentType("text/html");

      // Actual logic goes here.
      PrintWriter out = response.getWriter();
     
      //Perform the actual bid placement process
	  String msg = doBid(userName, productId, bid);
	  
	  //Send the final response to the requester
	  out.println(msg);
	  System.out.println(msg);
	     }

	/****
		This method perform bid placement process
	***/
   
   
   public String doBid(String userName, String productId, String bid)
   {
		
		String msg="not";
		
		
		try{
			applicationDBManager dbm = new applicationDBManager();
			
			// Get start bid
			ResultSet rsProd = dbm.getProductById(Integer.parseInt(productId));
			double startBid = 0;
			if (rsProd.next()){
				startBid = rsProd.getDouble("start_bid");
			}
			
			// Get highest bid
			ResultSet rsHighest = dbm.getHighestBid(Integer.parseInt(productId));
			double highest = 0;
			if (rsHighest.next()){
				if (rsHighest.getString("highest_bid") != null){
					highest = rsHighest.getDouble("highest_bid");
				}
			}
			
			double bidVal = Double.parseDouble(bid);
			if (bidVal > startBid && bidVal > highest){
				boolean rs = dbm.placeBid(Integer.parseInt(productId), userName, "" + bidVal);
				if (rs){ msg="ok"; }
			}
			
			rsProd.close();
			rsHighest.close();
			dbm.close();
	} catch(Exception e)
	   {
		   e.printStackTrace();
	   }
	   finally{
		//Return the actual message
			return msg;
		}
   }


   public void destroy() {
      // do nothing.
   }
}
