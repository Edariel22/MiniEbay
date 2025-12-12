
// Clase para el paquete MiniEbay.
package ut.JAR.miniebay;

// Importa el paquete java.sql para poder usar la clase de ResultSet.
import java.sql.* ;

/*
 *	Esta clase maneja la conexion con la base de datos por el front-end. Por eso,
 *	esta clase debe tener todos los metodos para manejar datos sin enseñar como se conecta con la base de datos.
 */
public class applicationDBManager{

	//Objeto para conectarse con la base de datos.
	private MySQLCompleteConnector myDBConn;
	
/*
 *	Constructor Default
 *	Crea un objeto MySQLCompleteConnector para conectarse con la base de datos.
 *		@parameters:
 */
	public applicationDBManager(){
	//Crea el objeto CompleteConnector.
		myDBConn = new MySQLCompleteConnector();
		
	//Abre la conexion con la base de datos.
		myDBConn.doConnection();
	}
	
//Metodos añadidos para que funcione el miniebay.

/*
 *	metodo addProduct, incluye el nombre del producto, descripcion del producto,
 *	departamento del producto, oferta del producto, fecha limite del producto,	
 *	nombre del usuario que añadio el producto y la foto, pero en string como su localizacion.
 *		@parameters:
 *			productName:	El nombre del producto nuevo.
 *			description:	La descripcion del producto nuevo.
 *			dept_id:		El id del nuevo departamento del producto.
 *			bid:			La  oferta del producto nuevo.
 *			dueDate:		La fecha limite del producto nuevo.
 *			picture_path:	La foto especificamente su path.
 *		@returns:
 *			Regresa ResultSet con en cierto o falso si se logro añadir.
 */
	public boolean addProduct(String productName, String description, String dept_id, String bid, String dueDate, String picture_path, String userName)
	{
		//Busca la tabla que se va a modificar.
		String table="products";

		//Busca el producto que se va a añadir (primer NULL es ID, y penultimo NULL es fecha de añadido).
		String values="NULL, '"+ productName +"', '" + description + "', '"+ dept_id +"', '" + bid +"', '" + dueDate +"', '"+ picture_path+ "', NULL , '"+ userName +"'";

		//Crea un boolean que es falso al principio, por si falla su parte.
		boolean rs;
		//Añade usando el doInsert.
		rs=myDBConn.doInsert(table, values);

		if (rs) {
			System.out.println("Product Successfully added: " + productName);
		} else {
			System.out.println("Couldn't add the new product to the database: " + productName);
		}
		
		//Retorna el valor cierto o falso dependiendo si se logro añadir o no.
		return rs;
	}
	
/*
 *	metodo addDepartment, incluye el ID del departamento, descripcion del producto,
 *	departamento del producto, oferta del producto, fecha limite del producto,	
 *	nombre del usuario que añadio el producto y la foto, pero en string como su localizacion.
 *	Esta funcion es exclusiva de admins, los usuarios normales no tienen acceso a esta funcion.
 *		@parameters:
 *			dept_id:	El ID del nuevo departamento.
 *			name:		El nombre del nuevo departamento.
 *			building:	El edificio del nuevo departamento.
 *		@returns:
 *			Regresa ResultSet con en cierto o falso si se logro añadir.
 */
	public boolean addDepartment(String name, String building)
	{

		//Busca la tabla que se va a modificar.
		String table="departments";
		
		//Busca el departamento que se va a añadir.
		String values="NULL, '" + name + "', '" + building + "'";

		//Crea un boolean que es falso al principio, por si falla su parte.
		boolean rs;
		//Añade usando el doInsert.
		rs=myDBConn.doInsert(table, values);

		System.out.println("Result of the insertion: " + rs);

		//Retorna el valor cierto o falso dependiendo si se logro añadir o no.
		return rs;
	}

/*
 *	Metodo modifyProduct, para cambiar el nombre, descripcion, departamento, fecha y la foto de un producto.
 *	Funcion tambien exclusiva de admins.
 *		@parameters:
 *			productId:		El ID del producto para encontrarlo facilmente.
 *			newProductName:	El nuevo nombre del producto.
 *			newDescription:	La nueva descripcion del producto.
 *			newDeptName:	El nuevo departamento del producto.
 *			newBid:			La nueva oferta del producto.
 *			newDueDate:		La nueva fecha limite del producto.
 *			newPicturePath:	La nueva foto (especificamente su path).
 *		@returns:
 *			Regresa ResultSet con en cierto o falso si se logro modificar.
 */
	public boolean updateProduct(int productId, String newProductName, String newDescription, int newDeptId, String newBid, String newDueDate, String newPicturePath,
	String newAddDate, String newUserName) {
		//Crea un boolean que es falso al principio, por si falla su parte, y fuera del try para que java no llore.
		boolean rs = false;
		try {
			// Declara y define las tablas que se van a modificar (Primer NULL es el ID).
			String table = "products";
			// Que lista mas larga lmao.
			String fields="product_id = '" + productId + "', name = '" + newProductName + "', dept_id = '"
			+ newDeptId + "', due_date = '" + newDueDate + "', picture_path = '" + newPicturePath
			+ "', created_at = '" + newAddDate + "', userName = '" + newUserName + "'";
			//Condicion para que solo se modifique el producto especificado por su ID
			String condition = "product_id = " + productId;
			//Actualiza el objeto usando doUpdate.
			rs = myDBConn.doUpdate(table, fields, condition);
			
			//Si se logra correr, el producto pudo ser modificado, si no, el producto no existe con ese ID.
			if (rs) {
				System.out.println("Product ID: " + productId + " has been updated successfully.");
			} else {
				System.out.println("Product ID: " + productId + " doesn't exist.");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		//Retorna el valor cierto o falso dependiendo si se logro modificar o no.
		return rs;
	}

/*
 *	Metodo updateDepartment modifica un departamento, usa el id original para buscarlo y se cambia su nombre, id y su edificio.
 *	Solo lo pueden usar los admins.
 *		@parameters:
 *			dept_id:			El ID del departamento para encontrarlo facilmente.
 *			newName:			El nuevo nombre que se le va a asignar.
 *			newBuildingName:	El nuevo edificio que se le va a asignar.
 *		@returns:
 *			Regresa ResultSet con en cierto o falso si se logro modificar.
 */
	public boolean updateDepartment(int dept_id, String newName, String newBuildingName) {
		// Crea un boolean que es falso al principio, por si falla su parte, fuera del try para que java no llore.
		boolean rs = false;
		//Intenta modificar un departamento seleccionado.
		try {

			// Declara y define las tablas que se van a modificar.
			String table = "departments";
			String fields="dept_id = '" + dept_id + "', name = '" + newName + "', building = '" + newBuildingName + "'";
			// Condicion para que solo se modifique el departamento especificado por su ID.
			String condition = "dept_id = '" + dept_id + "'";
	
			// Actualiza usando el metodo doUpdate.
			rs = myDBConn.doUpdate(table, fields, condition);
			
			// Si se logra correr, el departamento pudo ser modificado, si no, el producto no existe con ese ID. 
			if (rs) {
				System.out.println("Department details for department: " + dept_id + " have been updated successfully");
			} else {
				System.out.println("No department with ID: " + dept_id + " was found.");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		// Retorna el valor cierto o falso dependiendo si se logro modificar o no.
		return rs;
	}

/*
 *	Metodos listProducts, enseña todos los productos en la base de datos, si no tiene un valor especificado de dept_id.
 *	Son dos funciones para si se busca en la base de datos general, o si solamente se busca en un departamento especifico.
 *		@parameters:
 *			productName:	El nombre del producto para buscarlo.
 *		@returns:
 *			Regresa ResultSet con el o los productos con ese nombre en toda la base de datos. 
 */

// Funcion con solo el nombre del producto (busca en la base de datos en general).
	public ResultSet listProducts(String productName) {

		// Busca en toda la tabla que se va a utilizar (por eso el *).
		String fields = "*";

		// Busca la tabla que se va a modificar.
		String table = "products";

		// Busca especificamente usando nombre el producto escrito.
		String condition = "name = '" + productName + "'";
		if (productName != null && !productName.isEmpty() || productName == "") {
		/* Busca especificamente usando nombre el producto escrito.
		 * Regresa un ResultSet con los productos con ese nombre en la base de datos.
		 */
		return myDBConn.doSelect(fields, table, condition);
		} else {
		/* Si el producto esta vacio, enseña todos los objetos en la base de datos (en este caso que el dept_id no esta especificado).
		 * Regresa un ResultSet con todos los productos en la base de datos.
		 */
		return myDBConn.doSelect(fields, table);
		}
	}
/* Funcion con el nombre y el dept_id para buscar en la base de datos en el departamento especifico.
 *		@parameters:
 *			productName:	El nombre del producto para buscarlo.
 *			dept_id:		para buscarlo en un departamento especifico.
 *		@returns:
 *			Regresa ResultSet con el id del producto especificado en el departamento escogido, o con todos los productos
 *			en el departamento escogido.
 */
	public ResultSet listProducts(String productName, String dept_id) {

		// Busca en toda la tabla que se va a utilizar (por eso el *).
		String fields = "*";

		// Busca la tabla que se va a modificar.
		String table = "products";

		String condition;
		
		if (productName != null && !productName.isEmpty() || productName == "") {
		/* Busca especificamente usando nombre el producto escrito
		 * y cambia la condicion para que sea el nombre del producto y el id del departamento.
		 */
		condition = "name = '" + productName + "' AND dept_id = '" + dept_id + "'";
		} else {
		/* Si el producto esta vacio, enseña todos los objetos en la base de datos (en este caso que el dept_id no esta especificado)
		 * Cambia la condicion a que enseñe todos los productos en un departamento.
		 */
		condition ="dept_id = '" + dept_id + "'";
		}
		
		// Regresa un ResultSet con todos los productos (o los productos con un nombre especifico) en la base de datos en un departamento especifico.
		return myDBConn.doSelect(fields, table, condition);
	}


/*	metodo getProductById, para buscar el ID de un producto (para facilitar busquedas especificas) y retorna ese ID.
 *		@parameters:
 *			productId:	el ID del producto para encontrarlo facilmente.
 *		@returns:
 *			Regresa ResultSet con el id del producto especificado.
 */
	public ResultSet getProductById(int productId) {

		// Busca en toda la tabla que se va a utilizar (por eso el *).
		String fields = "*";

		// Busca la tabla que se va a modificar.
		String table = "products";

		// Busca especificamente usando el id el producto escrito.
		String condition = "product_id = '" + productId + "'";

		// Regresa un ResultSet con el ID del producto especificado.
		return myDBConn.doSelect(fields, table, condition);
	}

/*
 *	Metodo listAllDepartments, generalmente utilizado para los dropdowns en los menus,
 *	enseña todos los departamentos en la base de datos.
 *		@parameters:
 *		@returns:
 *			Regresa ResultSet con todos los departamentos en la base de datos.
 */
	public ResultSet listAllDepartments() {

		// Busca en toda la tabla que se va a utilizar (por eso el *).
		String fields = "*";

		// Busca la tabla que se va a modificar.
		String table = "departments";

		// Retorna un ResultSet con todos los departamentos en la base de datos.
		return myDBConn.doSelect(fields, table);
	}


/* 	Metodo removeProduct, enseña los productos dependiendo de su productId para borrarlos.
 *	Solo lo pueden usar los admins.
 *		@parameters:
 *			productId:	el ID del producto para encontrarlo facilmente.
 *		@returns:
 *			Regresa ResultSet en cierto o falso si se logro borrar el producto.
 */
	public boolean removeProduct(int productId) {

		// Busca la tabla que se va a modificar.
		String table = "products";

		// Busca el producto que se va a borrar.
		String condition = "product_id = '" + productId + "'";
		
		// Crea un boolean que es falso al principio, por si falla su parte.
		boolean rs = false;

		// Borra usando el doDelete.
		rs = myDBConn.doDelete(table, condition);
		
		if (rs) {
			System.out.println("Product Successfully deleted: " + productId);
		} else {
			System.out.println("Couldn't delete Product: " + productId);
		}
		
		//Retorna el valor cierto o falso dependiendo si se borro o no.
		return rs;
	}


/*	Metodo removeDepartment, enseña los productos dependiendo de su dept_id para borrarlos, igual a arriba, pero por departamento.
 *	Solo lo pueden usar los admins.
 *		@parameters:
 *			dept_id:	El ID del departamento para encontrarlo facilmente.
 *		@returns:
 *			Regresa ResultSet en cierto o falso si se logro borrar el departamento.
 */
	public boolean removeDepartment(int dept_id) {

		// Busca la tabla que se va a modificar.
		String table = "departments";

		// Busca el producto que se va a borrar.
		String condition = "dept_id = '" + dept_id + "'";
		
		// Crea un boolean que es falso al principio, por si falla su parte.
		boolean rs = false;

		// Borra usando el doDelete.
		rs = myDBConn.doDelete(table, condition);
		
		if (rs) {
			System.out.println("Department Successfully deleted: " + dept_id);
		} else {
			System.out.println("Couldn't delete Department: " + dept_id);
		}
		
		// Retorna el valor cierto o falso dependiendo si se borro o no.
		return rs;
	}


/*	Metodo placeBid, para modificat la oferta en un producto (cuanto ofrece un usuario para un objeto).
 *		@parameters:
 *			bid:		Añade un valor de oferta a un producto.
 *			userName:	El nombre del usuario que quiere poner dicha oferta.
 *			productId:	Identifica el producto de forma sencilla en la base de datos.
 *		@returns:
 *			Regresa ResultSet en cierto o falso si se logro añadir la oferta.
 */
public boolean placeBid(int productId, String userName, String Bid) {
	// Crea un boolean que es falso al principio, por si falla su parte, fuera del try para que java no llore.
	boolean rs = false;
    try {
		// Busca la tabla que se va a modificar.
        String table = "bids";
        
		// Busca la oferta que se va a añadir(primer NULL es el ID y ultimo NULL es fecha de añadido).
        String values = "NULL, '" + productId + "', '" + userName + "', '" + Bid +"', NULL";

        // Añade usando el doInsert.
        rs = myDBConn.doInsert(table, values);
        
        if (rs) {
            System.out.println("Bid added for product ID: " + productId + " successfully.");
        } else {
            System.out.println("Could not add a bid for product ID: " + productId);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return rs;
}

/* Metodo getHighestBid, para cuando se quiere sacar la oferta mas alta del objeto.
 *		@parameters:
 *			productId:	Identifica el producto de forma sencilla en la base de datos.
 *		@returns:
			Retorna la oferta mas alta del objeto especificado.
 */
    public ResultSet getHighestBid(int productId) {

			// Declara y define las tablas que se van a modificar.
			String fields = "MAX(amount) AS highest_bid"; // en este caso, el valor mas alto.
			String tables = "bids";

			// Busca el producto que se va a modificar.
			String condition = "product_id = " + productId;
			
		// Regresa un ResultSet con el bid mas alto del producto especificado.
        return myDBConn.doSelect(fields, tables, condition);
    }



/*
 *	Metodo close, para cerrar la conexion con la base de datos.
 *	Se tiene que llamar al final de cada pagina u objeto que llame al applicationDBManager.
 *		@parameters:
 *		@returns:
 */
	public void close()
	{
		// Cierra la conexion.
		myDBConn.closeConnection();
	}
    
}