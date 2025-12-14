// Import required java libraries
import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.util.*;
import org.json.*;
import ut.JAR.miniebay.*;
import java.sql.*;

/***
	This servlet generates a JSON object and sent it the a web browswer when required
*/


// Extend HttpServlet class
public class getDataBaseJson extends HttpServlet {
 
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
		JSONObject jsonResult = createFinalJSON();
      
      // Actual logic goes here.
      PrintWriter out = response.getWriter();
	  
	  // Set response content type
	  response.setContentType("application/json");
	  response.setCharacterEncoding("UTF-8");
      //Send the response
	  out.println(jsonResult.toString());
	     }

   public void destroy() {
      // do nothing.
   }
   
   /**
	Create a JSONObject containg a JSONArray
   **/
   public JSONObject createFinalJSON()
   {
		//Create the JSONObject	
	   JSONObject finalOutput = new JSONObject();
	   try{
		    //Create the JSONObject cointaing a JSONArray created using the createJSonArray method
			//name the JSONObject as "contact"
			finalOutput.put("products", createJSonArray());
	   }catch(Exception e)
	   {
		   e.printStackTrace();
	   }
	   finally{
		   //Return the JSONObject cointaing the array
		   return finalOutput;
	   }
   }
   
   /**
	Create a JSONArray
	@param count: number of elements in the array
   */
   
   public JSONArray createJSonArray()
   {
	   
	   //Create the JSONArray
		   JSONArray jsonArray = new JSONArray();
	   
	   //Connect the the database
		applicationDBManager dbm = new applicationDBManager();
		int i=0;
		try{
			//query the database
			ResultSet res= dbm.listProducts(null);
			System.out.println("list all products");
			while (res.next()){				//Add the new JSONObject to the JSONArray in location i
				System.out.println("ROW → " + res.getString("product_id"));
				jsonArray.put(i,createJSon(res));
				i++;
			}
			
		dbm.close();
		
	} catch(Exception e)
	   {
		   e.printStackTrace();
	   }
	   finally{
		   //Return the JSONArray
		   return jsonArray;
	   }
   }
   
   
   /*
		This method creates a JSONObject
   
   */ 
   public JSONObject createJSon(ResultSet res)
   {
	   	applicationDeptManager dbd = new applicationDeptManager();
	   //Create the JSONObject
	   JSONObject json = new JSONObject();
	   try{
			//Add the appropriate data to the object
			json.put("id", res.getInt("product_id"));
			json.put("name", res.getString("name"));
			json.put("description", res.getString("description"));
			json.put("department_id", res.getInt("dept_id"));
			ResultSet	rsDept = dbd.getDepartmentById(res.getInt("dept_id"));
				if (rsDept.next()) {
			json.put("department_name", rsDept.getString("name"));
				}
				rsDept.close();

			json.put("start_bid", res.getDouble("start_bid"));
			json.put("due_date", res.getString("due_date"));
			json.put("image", res.getString("picture_path"));
			json.put("created_at", res.getString("created_at"));
			json.put("seller", res.getString("userName"));
		dbd.close();
			
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
