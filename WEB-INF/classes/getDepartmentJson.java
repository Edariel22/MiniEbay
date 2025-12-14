// Import required java libraries
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.util.*;
import org.json.*;
import ut.JAR.miniebay.*;
import java.sql.*;

/***
	This servlet generates a JSON object and sent it the a web browser when required
*/


// Extend HttpServlet class
public class getDepartmentJson extends HttpServlet {
 
   //Users list (ArrayList)
   //private ArrayList<userClass> users;
   
   //Servlet initialization
   public void init() throws ServletException {
      // Do required initialization
         }

	public void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
	
		this.doPost(request, response);
	  }

	/* doGet Method
		Generates a JSON object containg a JSON Array list
	*/
   public void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {
	
		//Create an JSONObject containing a JSONArray
		JSONObject jsonDeptResult = createDeptJSON();
      
      // Actual logic goes here.
      PrintWriter out = response.getWriter();
	  
	  // Set response content type
	  response.setContentType("application/json");
	  response.setCharacterEncoding("UTF-8");
      //Send the response
	  out.println(jsonDeptResult.toString());
	     }

   public void destroy() {
      // do nothing.
   }
   
      /**
	Create a JSONObject containg a JSONArray
   **/
   public JSONObject createDeptJSON()
   {
		//Create the JSONObject	
	   JSONObject deptOutput = new JSONObject();
	   try{
		    //Create the JSONObject cointaing a JSONArray created using the createJSonArray method
			//name the JSONObject as "contact"
			deptOutput.put("departments", createJSonDeptArray());
	   }catch(Exception e)
	   {
		   e.printStackTrace();
	   }
	   finally{
		   //Return the JSONObject cointaing the array
		   return deptOutput;
	   }
   }
   
   /**
	Create a JSONArray
	@param count: number of elements in the array
   */
   
   public JSONArray createJSonDeptArray()
   {
	   
	   //Create the JSONArray
		   JSONArray jsonDeptArray = new JSONArray();
	   
	   //Connect the the database
		applicationDBManager dbm = new applicationDBManager();
		int i=0;
		try{
			//query the database
			ResultSet res= dbm.listAllDepartments();
			System.out.println("list all departments");
			while (res.next()){				//Add the new JSONObject to the JSONArray in location i
				System.out.println("ROW → " + res.getString("name"));
				jsonDeptArray.put(i,createDeptJSon(res));
				i++;
			}
			
		dbm.close();
		
	} catch(Exception e)
	   {
		   e.printStackTrace();
	   }
	   finally{
		   //Return the JSONArray
		   return jsonDeptArray;
	   }
   }
   
   
   /*
		This method creates a JSONObject
   
   */ 
   public JSONObject createDeptJSon(ResultSet res)
   {
	   //Create the JSONObject
	   JSONObject json = new JSONObject();
	   try{
			//Add the appropriate data to the object
			json.put("dept_id", res.getInt("dept_id"));
			json.put("name", res.getString("name"));
			
	} catch(Exception e)
	   {
		   e.printStackTrace();
	   }
	   finally{
		   //return the JSONObject
		   return json;
	   }
   }
}
