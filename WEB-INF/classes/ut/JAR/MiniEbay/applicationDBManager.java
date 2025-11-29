
//This class belongs to the ut.JAR.MiniEbay package
package ut.JAR.miniebay;

//Import the java.sql package for managing the ResulSet objects
import java.sql.* ;

/******
	This class manage a connection to the Department database and it should be accessed from the front End. Therefore,
	this class must contain all needed methods for manipulating data without showing how to access the database

*/
public class applicationDBManager{

	//myDBConn is an MySQLConnector object for accessing to the database
	private MySQLCompleteConnector myDBConn;
	
	/********
		Default constructor
		It creates a new MySQLConnector object and open a connection to the database
		@parameters:
		
	*/
	public applicationDBManager(){
		//Create the MySQLConnector object
		myDBConn = new MySQLCompleteConnector();
		
		//Open the connection to the database
		myDBConn.doConnection();
	}
	
	
	/*******
		listAllDepartment method
			List all departments in the database
			@parameters:
			@returns:
				A ResultSet containing all departments in the database
	*/
	public ResultSet listAllDepartment()
	{
		
		//Declare function variables
		String fields, tables;
		
		//Define the table where the selection is performed
		tables="departments";
		//Define the list fields list to retrieve from the table department
		fields ="dept_id, name, building";
		
		
		System.out.println("listing...");
		
		//Return the ResultSet containing all departments in the database
		return myDBConn.doSelect(fields, tables);
		
		
	}
    //add department helper method for adminDepartments.jsp
    public boolean addDepartment(String name, String building) {
        String table = "departments";
        String values = "NULL, '" + name + "', '" + building + "'";
        return myDBConn.doInsert(table, values);
    }
    //remove department helper method for adminDepartments.jsp
    public boolean removeDepartment(int deptId) {
        String table = "departments";
        String condition = "dept_id = " + deptId;
        return myDBConn.doDelete(table, condition);
    }
        



    
    //Para enlistar los productos de forma sencilla (para findProduct.jsp)
    public ResultSet listProducts(String name, String dept) {
        applicationProductManager pm = new applicationProductManager();
        return pm.listProducts(name, dept);
    }

    // Esto es para enseñarle los productos a los admins.
    public ResultSet listProductsAdmin() {
        applicationProductManager pm = new applicationProductManager();
        return pm.listAllProducts();
    }


    // Esto es para cuando un admin añade un producto.
    public boolean addProductAdmin(String name, String deptId, String startBid, String dueDate) {
        applicationProductManager pm = new applicationProductManager();
        return pm.addProduct(name, deptId, startBid, dueDate);
    }

    // Esto es para cuando un quiere remover un producto.
    public boolean removeProductAdmin(int productId) {
        applicationProductManager pm = new applicationProductManager();
        return pm.removeProduct(productId);
    }
    public ResultSet getProductById(int productId) {
        applicationProductManager pm = new applicationProductManager();
        return pm.getProductById(productId);
    }
		// Esto es para vender un producto.
	public boolean addProduct(String name, String desc, String deptId, String startBid, String dueDate, String picture, String userName) {
		String table = "products";
		String values = "NULL,'" + name + "','" + desc + "'," + deptId + "," + startBid + ",'" + dueDate + "','" + picture + "',NULL,'" + userName + "'";
		return myDBConn.doInsert(table, values);
	}









    // Esto es para la asistencia de Admins.
    
    public ResultSet listAllUsers() {
    applicationUserManager um = new applicationUserManager();
    return um.listAllUsers();
}
    // Esto es para cuando un admin añade un usuario.
    public boolean addUserAdmin(String userName, String hashing, String name, String telephone, String roleId) {
        applicationUserManager um = new applicationUserManager();
        boolean rs = um.addUser(userName, hashing, name, telephone, roleId);
        um.close();

        return rs;
    }

    // Esto es para cuando un admin remueve un usuario.
    public boolean removeUserAdmin(String userName) {
        applicationUserManager um = new applicationUserManager();
        boolean rs = um.removeUser(userName);
        um.close();
        return rs;
    }
	// Esto es para cuando un admin modifica a un usuario.
	public boolean updateUserAdmin(String userName, String hashing, String name, String telephone, String roleId) {
		applicationUserManager um = new applicationUserManager();
		boolean result = um.updateUser(userName, hashing, name, telephone, roleId);
		um.close();
		return result;
	}


    // Esto es para cuando se quiere poner una nueva oferta.
    public boolean placeBid(int productId, String userName, String amount) {
        String table = "bids";
        String values = "NULL, '" + productId + "', '" + userName + "', '" + amount + "', NOW()";
        return myDBConn.doInsert(table, values);
    }

    // Esto es para cuando se quiere sacar la oferta mas alta del objeto.
    public ResultSet getHighestBid(int productId) {
        String fields = "MAX(amount) AS highest_bid";
        String tables = "bids";
        String condition = "product_id = " + productId;
        return myDBConn.doSelect(fields, tables, condition);
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
    
	/***********
		Debugging method
			This method creates an applicationDBManager object, retrieves all departments in the database, and close the connection to the database
			@parameters:
				args[]: String array 
			@returns:
	*/
	public static void main(String[] args)
	{
		
		try{
			//Create a applicationDBManager object
			applicationDBManager appDBMnger = new applicationDBManager();
			System.out.println("Connecting...");
			System.out.println(appDBMnger.toString());
			
			//Call the listAllDepartment in order to retrieve all departments in the database
			ResultSet rs=appDBMnger.listAllDepartment();
			
			//Iterate over the ResulSet containing all departments in the database, and count how many tuples were retrieved
			int count=0;
			while (rs.next()){
				count++;	
			}
			//Print the results count
			System.out.println("Count:"  + count);
			
			//Close the ResulSet
			rs.close();
			//Close the database connection
			appDBMnger.close();
			
		} catch(Exception e)
		{
			//Nothing to show!
			e.printStackTrace();
		}		
	}

}