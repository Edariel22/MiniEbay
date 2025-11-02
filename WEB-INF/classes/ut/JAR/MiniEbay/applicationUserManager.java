
//This class belongs to the ut.JAR.MiniEbay package
package ut.JAR.miniebay;

//Import the java.sql package for managing the ResulSet objects
import java.sql.* ;

/******
	This class manage a connection to the Department database and it should be accessed from the front End. Therefore,
	this class must contain all needed methods for manipulating data without showing how to access the database

*/
public class applicationUserManager{

	//myDBConn is an MySQLConnector object for accessing to the database
	private MySQLCompleteConnector myDBConn;
	
	/********
		Default constructor
		It creates a new MySQLConnector object and open a connection to the database
		@parameters:
		
	*/
	public applicationUserManager(){
		//Create the MySQLConnector object
		myDBConn = new MySQLCompleteConnector();
		
		//Open the connection to the database
		myDBConn.doConnection();
	}
	
	
    public ResultSet listAllUsers() {

            //Declare function variables
            String fields, tables;
            
            //Define the list of fields to retrieve from the user and roleuser tables
            fields = "users.userName, users.name, users.telephone, roleuser.roleId";
            
            //Define the tables and the join condition
            tables = "users JOIN roleuser ON users.userName = roleuser.userName";
            
            System.out.println("Listing all users...");
            
            //Return the ResultSet containing all users in the database
            return myDBConn.doSelect(fields, tables);
        }
        
	// addUser method - Add a new user into the database
	
	public boolean addUser(String userName, String hashing, String name, String telephone, String roleId) {

		//Prepare the SQL insert statements for both users and roleuser tables
		String tableUsers = "users";
		String valuesUsers = "'" + userName + "', '" + hashing + "', '" + name + "', '" + telephone + "'";
		
		String tableRoleUser = "roleuser";
		String valuesRoleUser = "'" + userName + "', '" + roleId + "'";
		
		System.out.println("Adding user: " + userName);
		
		//Insert into users table
		boolean insertUser = myDBConn.doInsert(tableUsers, valuesUsers);
		
		//Insert into roleuser table only if first insert succeeded
		if (insertUser) {
			boolean insertRole = myDBConn.doInsert(tableRoleUser, valuesRoleUser);
			return insertRole;
		} else {
			return false;
		}
	}

    // Delete user method
    public boolean removeUser(String userName) {

		//Define the table and condition for deletion
		String table = "users";
		String condition = "userName = '" + userName + "'";
		
		System.out.println("Removing user: " + userName);
		
		//Return true if deleted successfully
		return myDBConn.doDelete(table, condition);
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