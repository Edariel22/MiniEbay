
// Clase para el paquete MiniEbay.
package ut.JAR.miniebay;

// Importa el paquete java.sql para poder usar la clase de ResultSet.
import java.sql.* ;

/*
 *	Esta clase maneja la conexion con la base de datos por el front-end. Por eso,
 *	esta clase debe tener todos los metodos para manejar datos sin enseñar como se conecta con la base de datos.
 */
public class applicationDeptManager{

	//Objeto para conectarse con la base de datos.
	private MySQLCompleteConnector myDBConn;
	
/*
 *	Constructor Default
 *	Crea un objeto MySQLCompleteConnector para conectarse con la base de datos.
 *		@parameters:
 */
	public applicationDeptManager(){
	//Crea el objeto CompleteConnector.
		myDBConn = new MySQLCompleteConnector();
		
	//Abre la conexion con la base de datos.
		myDBConn.doConnection();
	}
	
//Solamente el metodo del ID para dejar de sufrir con dbm en un loop.

/*	metodo getDepartmentById, para buscar el ID de un departamento (para facilitar busquedas especificas) y retorna el nombre del Departamento.
 *		@parameters:
 *			dept_id:	el ID del departamento para encontrarlo facilmente.
 *		@returns:
 *			Regresa ResultSet con el nombre del departamento especificado.
 */
	public ResultSet getDepartmentById(int dept_id) {

		// Busca en toda la tabla que se va a utilizar (por eso el *).
		String fields = "name";

		// Busca la tabla que se va a usar.
		String table = "departments";

		// Busca especificamente usando el id el departamento escrito.
		String condition = "dept_id = '" + dept_id + "'";

		// Regresa un ResultSet con los datos del departamento especificado.
		return myDBConn.doSelect(fields, table, condition);
	}

/*
 *	Metodo close, para cerrar la conexion con la base de datos.
 *	Se tiene que llamar al final de cada pagina u objeto que llame al applicationDeptManager.
 *		@parameters:
 *		@returns:
 */
	public void close()
	{
		// Cierra la conexion.
		myDBConn.closeConnection();
	}
    
}