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
	
		//Retrieve the text and department parameters from the request
		String text = request.getParameter("text");
		String dept = request.getParameter("dept");

		//Create an JSONObject containing a JSONArray with the text and department parameters
		JSONObject jsonResult = createFinalJSON(text, dept);
      
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
	@param text: name of the product
	@param dept: department of the product
   **/
   public JSONObject createFinalJSON(String text, String dept)
   {
		//Create the JSONObject	
	   JSONObject finalOutput = new JSONObject();
	   try{
		    //Create the JSONObject cointaing a JSONArray created using the createJSonArray method
			// name the JSONObject as "products"
			//text is the name of the product, dept is the department of the product
			// I added it here to be able to search for a product by name or department
			finalOutput.put("products", createJSonArray(text, dept));
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
	@param text: name of the product
	@param dept: department of the product
   */
   
   public JSONArray createJSonArray(String text, String dept)
   {
		if (text != null && text.trim().isEmpty()) {
			text = null;
		}
		
		int deptId = 0;
		if (dept != null && !dept.trim().isEmpty()) {
			deptId = Integer.parseInt(dept);
		}
		
	   //Create the JSONArray
		   JSONArray jsonArray = new JSONArray();
	   
	   //Connect the the database
		applicationDBManager dbm = new applicationDBManager();
		int i=0;
		
		
		
		try{
			//query the database
			ResultSet res= dbm.listProducts(null);
			
			System.out.println("list products");
			while (res.next()){				//Add the new JSONObject to the JSONArray in location i
				System.out.println("ROW → " + res.getString("product_id"));
				String name = res.getString("name");
				String description = res.getString("description");
				int deptDb = res.getInt("dept_id");

				// FILTER BY TEXT
				if (text != null) {
					String t = text.toLowerCase();
					if (!name.toLowerCase().contains(t) &&
						!description.toLowerCase().contains(t)) {
						continue;
					}
				}

				// FILTER BY DEPARTMENT
				if (deptId != 0 && deptDb != deptId) {
					continue;
				}

				jsonArray.put(i, createJSon(res));
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
