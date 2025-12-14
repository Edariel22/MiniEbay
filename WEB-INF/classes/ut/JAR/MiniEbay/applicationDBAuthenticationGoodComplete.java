
//This class belongs to the ut.JAR.miniebay package
package ut.JAR.miniebay;

//Import the java.sql package for managing the ResulSet objects
import java.sql.* ;

//Import hashing functions
import org.apache.commons.codec.*;

/******
	This class authenticate users using userName and passwords

*/
public class applicationDBAuthenticationGoodComplete{

	//myDBConn is an MySQLCompleteConnector object for accessing to the database
	private MySQLCompleteConnector myDBConn;
	
	/********
		Default constructor
		It creates a new MySQLCompleteConnector object and open a connection to the database
		@parameters:
		
	*/
	public applicationDBAuthenticationGoodComplete(){
		//Create the MySQLCompleteConnector object
		myDBConn = new MySQLCompleteConnector();
		
		//Open the connection to the database
		myDBConn.doConnection();
	}
	
	
	/*******
		authenticate method
			Authentication method
			@parameters:
			@returns:
				A ResultSet containing the userName and all roles assigned to her.
	*/
	public ResultSet authenticate(String userName, String userPass)
	{
		
		//Declare function variables
		String fields, tables, whereClause, hashingVal;
		
		//Define the table where the selection is performed
		tables="users, roleuser";
		//Define the list fields list to retrieve assigned roles to the user
		fields ="users.userName, roleuser.roleId, users.Name";
		hashingVal = hashingSha256(userName + userPass);
		whereClause="users.userName = roleuser.userName and users.userName='" +userName +"' and hashing='" + hashingVal + "'";
		
		
		System.out.println("listing...");
		
		//Return the ResultSet containing all roles assigned to the user
		return myDBConn.doSelect(fields, tables, whereClause);
	}


	/*******
		menuElements method
			Authentication method
			@parameters:
			@returns:
				A ResultSet containing the userName and all roles assigned to her.
	*/
	public ResultSet menuElements(String userName)
	{
		
		//Declare function variables
		String fields, tables, whereClause, orderBy;
		
		//Define the table where the selection is performed
		tables="roleuser, role, rolewebpagegood, menuElement,webpagegood ";
		//Define the list fields list to retrieve assigned roles to the user
		fields ="rolewebpagegood.pageURL, menuElement.title, webpagegood.pageTitle";
		whereClause=" roleuser.roleID=role.roleID and role.roleID=rolewebpagegood.roleId and menuElement.menuID = webpagegood.menuID";
		whereClause+=" and rolewebpagegood.pageURL=webpagegood.pageURL";
		whereClause+=" and userName='"+ userName+"' order by menuElement.title, webpagegood.pageTitle;";
		
		
		System.out.println("listing...");
		
		//Return the ResultSet containing all roles assigned to the user
		return myDBConn.doSelect(fields, tables, whereClause);
	}	
	
	public ResultSet verifyUser(String userName, String currentPage, String previousPage)
	{
		
		//Declare function variables
		String fields, tables, whereClause, hashingVal;
		
		//Define the table where the selection is performed
		tables="roleuser, role, rolewebpagegood, webpagegood, users, webpageprevious";
		//Define the list fields list to retrieve assigned roles to the user
		fields ="users.userName, roleuser.roleId, users.Name ";
		whereClause=" users.userName = roleuser.userName and users.userName='" +userName +"' and role.roleId=roleuser.roleId and ";
		whereClause+=" rolewebpagegood.roleId=role.roleId and rolewebpagegood.pageURL=webpagegood.pageURL and webpagegood.pageURL='" +currentPage+"' and ";
		whereClause+=" webpageprevious.previousPageURL='"+previousPage+"' and webpageprevious.currentPageURL=webpagegood.pageURL";
		
		
		System.out.println("listing...");
		
		//Return the ResultSet containing all roles assigned to the user
		return myDBConn.doSelect(fields, tables, whereClause);
		
		
	}
/*
 *	Metodo addUser, para cuando un usuario hace sign up.
 *			@parameters:
 *				userName:		Para saber que usuario se va a añadir a la base de datos.
 *				CompleteName:	Nombre "real" del usuario.
 *				userPass:		Password para el usuario, se encripta con hashing.
 *				userTelephone:	Numero de telefono del usuario.
 *			@returns:
 *				Retorna cierto o falso dependiendo si logran cambiar los datos.
 */
	public boolean addUser(String userName, String completeName, String userPass, String userTelephone)
	{
		boolean rs;
		String table, values, hashingValue;
		hashingValue=hashingSha256(userName + userPass);
		table="users";
		values="'" + userName + "', '" + hashingValue + "', '" + completeName + "', '" + userTelephone + "'";
		rs=myDBConn.doInsert(table, values);
		System.out.println("Insertion result" + rs);
		return rs;
	}

/*
 *	Metodo setUserRole, para asignarle un rol al usuario cuando se crea una cuenta.
 *	Son dos funciones, ya que cuando se crea un usuario normalmente, siempre va a ser un user normal (rol2), pero por el lado de Admin, se usa la segunda funcion.
 *			@parameters:
 *				userName:	Para saber que usuario se le va a dar el rol.
 *			@returns:
 *				Retorna cierto o falso dependiendo si logra añadir.
 */
	public boolean setUserRole(String userName)
	{
		boolean rs;
		String table, values;
		table="roleuser";
		values="'" + userName + "', 'rol2'";
		rs=myDBConn.doInsert(table, values);
		System.out.println("Insertion result" + rs);
		return rs;
	}

// Version usada solo por el lado de Admin, para escoger el rol de un usuario.
	public boolean setUserRole(String userName, String userRoleId)
	{
		boolean rs;
		String table, values;
		table="roleuser";
		values="'" + userName + "', '" + userRoleId + "'";
		rs=myDBConn.doInsert(table, values);
		System.out.println("Insertion result" + rs);
		return rs;
	}

/*
 *	Metodo updateUser, para si un admin decide cambiarle los datos a un usuario.
 *			@parameters:
 *				userName:	Para saber que usuario se va a modificar.
 *				newPass:	Nuevo password para el usuario, se encripta con hashing.
 *				newName:	Nuevo nombre "real" del usuario.
 *				newName:	Nuevo numero de telefono del usuario.
 *			@returns:
 *				Retorna cierto o falso dependiendo si logran cambiar los datos.
 */
	public boolean updateUser(String userName, String newPass, String newName, String newTelephone)
	{
		boolean rs;
		String table, values, hashingValue;
		hashingValue=hashingSha256(userName + newPass);
		table="users";
		String condition = "userName = '" + userName + "'";
		values="userName = '" + userName + "', hashing = '" + hashingValue + "', name = '" + newName + "', telephone = '" + newTelephone + "'";
		rs=myDBConn.doUpdate(table, values, condition);
		System.out.println("Insertion result" + rs);
		return rs;
	}
/*
 *	Metodo updateUserRole, para si un admin decide cambiarle el rol a un usuario.
 *			@parameters:
 *				userName:	Para saber que usuario se va a modificar.
 *				newRoleID:	Para saber que rol se le va a asignar (rol1 admin, rol2 user).
 *			@returns:
 *				Retorna cierto o falso dependiendo si logra cambiar el rol.
 */
	public boolean updateUserRole(String userName, String newRoleID)
	{
		boolean rs;
		String table, values;
		table="roleuser";
		String condition = "userName = '" + userName + "'";
		values="userName = '" + userName + "', roleID = '" + newRoleID + "'";
		rs=myDBConn.doUpdate(table, values, condition);
		System.out.println("Insertion result" + rs);
		return rs;
	}

/*
 *	Metodo removeUser, para remover un usuario de la base de datos.
 *			@parameters:
 *				userName:	Para saber que usuario borrar.
 *			@returns:
 *				Retorna cierto o falso dependiendo si logra borrarlo.
 */
    public boolean removeUser(String userName) {

		//Define the table and condition for deletion
		String table = "users";
		String condition = "userName = '" + userName + "'";
		
		System.out.println("Removing user: " + userName);
		
		//Retorna cierto si logra borrarlo.
		return myDBConn.doDelete(table, condition);
	}
	
/*
 *	Metodos listUsersAndRoles, enseña todos los usuarios en la base de datos con sus roles.
 *		@parameters:
 *		@returns:
 *			Regresa ResultSet con el o los usuarios en toda la base de datos con sus roles. 
 */
	public ResultSet listUsersAndRoles() {

		// Busca en las tablas que se va a utilizar.
		String fields = "users.userName, roleuser.roleId, users.Name, users.telephone";

		// Busca la tabla que se va a modificar.
		String table = "users, roleuser";

		String whereClause=" users.userName = roleuser.userName";
		// Regresa un ResultSet con todos los roles por usuario en la base de datos.
		return myDBConn.doSelect(fields, table, whereClause);
	}

	/*********
		hashingSha256 method
			Generates a hash value using the sha256 algorithm.
			@parameters: Plain text
			@returns: the hash string based on the plainText
	*/
	private String hashingSha256(String plainText)
	{
			String sha256hex = org.apache.commons.codec.digest.DigestUtils.sha256Hex(plainText); 
			return sha256hex;
	}
	
	public String getHashedValue(String userName, String userPass) {
		return hashingSha256(userName + userPass);
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