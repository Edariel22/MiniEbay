
//This class belongs to the ut.JAR.MiniEbay package
package ut.JAR.MiniEbay;

//Import the java.sql package for managing the ResulSet objects
import java.sql.* ;

/******
	This class manage a connection to the Department database and it should be accessed from the front End. Therefore,
	this class must contain all needed methods for manipulating data without showing how to access the database

*/
public class applicationProductManager{

	//myDBConn is an MySQLConnector object for accessing to the database
	private MySQLConnector myDBConn;
	
	/********
		Default constructor
		It creates a new MySQLConnector object and open a connection to the database
		@parameters:
		
	*/
	public applicationProductManager(){
		//Create the MySQLConnector object
		myDBConn = new MySQLConnector();
		
		//Open the connection to the database
		myDBConn.doConnection();
	}
	
	
	/*******
		listAllProducts method
			List all products in the database
			@parameters:
			@returns:
				A ResultSet containing all products in the database
	*/
	public ResultSet listAllProducts()
	{
		
		//Declare function variables
		String fields, tables;
		
		//Define the table where the selection is performed
		tables="products";
		//Define the list fields list to retrieve from the table department
		fields ="*";
		
		
		System.out.println("listing...");
		
		//Return the ResultSet containing all departments in the database
		return myDBConn.doSelect(fields, tables);
		
		
	}
	
	/*********
		close method
			Close the connection to the database.
			This method must be called at the end of each page/object that instatiates a applicationDBManager object
			@parameters:
			@returns:
	*/
	
	
	
	
	// Helper method to get the name of department given id
	// Used in products.jsp to get the name of the department a product belongs to given dept id.
	
	public String getDepartmentName(int deptID){
		String name = "";
		try {
			//new connecter needed since it closes the older one being used if not using a new one
			MySQLConnector tempConn = new MySQLConnector();
			//Open the connection to the database
			tempConn.doConnection();

			// run a simple query
			ResultSet res = tempConn.doSelect("name", "departments", "dept_id = " + deptID);

			//  Check if res is null (no record found for this dept id)
			if (res != null && res.next()) {
				name = res.getString(1);
			} else {
				name = "unknown";
			}

			// clean up
			res.close();
			tempConn.closeConnection();

		} catch (Exception e) {
			name = "unknown";
		}
		return name;
	}

	
	
	
	// DOESNT WORK
	// Tried to implement to function the same as getDepartmentName, but couldnt figure it out
	public ResultSet listAllProductsWithDept()
	{
		
		//Declare function variables
		String fields, tables;
		
		fields = "p.name, p.description, p.start_bid, d.name, p.due_date, p.picture_path";
		tables = "products p JOIN departments d ON p.dept_id = d.dept_id";

		
		
		System.out.println("listing...");
		
		//Return the ResultSet containing all departments in the database
		return myDBConn.doSelect(fields, tables);
		
		
	}
	
	/*********
		close method
			Close the connection to the database.
			This method must be called at the end of each page/object that instatiates a applicationDBManager object
			@parameters:
			@returns:
	*/
	
	
	public void close()
	{
		//Close the connection
		myDBConn.closeConnection();
	}

	

}