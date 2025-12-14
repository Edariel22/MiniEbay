<%@ page import="java.lang.*"%>
<%@ page import="ut.JAR.miniebay.*" %>
<%//Import the java.sql package to use the ResultSet class %>
<%@ page import="java.sql.*"%>
<html>
	<head>
		<title>Mini Ebay: Find Products</title>
	</head>
    <body>
		
<%
		// Intenta conectar con la base de datos.
		try{
					//Revisa el proceso de autenticacion.
				if (session.getAttribute("userName") == null || session.getAttribute("currentPage") == null) {
					session.setAttribute("currentPage", null);
					session.setAttribute("userName", null);
					response.sendRedirect("loginHashing.html");
					
				}else{
					String currentPage = "findProduct.jsp";
					String userName = session.getAttribute("userName").toString();
					String previousPage = session.getAttribute("currentPage").toString();
					
					//Crea el objeto dba, (database authentication) para poder autenticar al usuario.
					applicationDBAuthenticationGoodComplete dba = new applicationDBAuthenticationGoodComplete();
					System.out.println("Connecting...");
					System.out.println(dba.toString());
					
					//Crea el objeto dbm, (database manager) para poder manejar la base de datos.
					applicationDBManager dbm = new applicationDBManager();
					System.out.println("Connecting...");
					System.out.println(dbm.toString());

					//Crea el objeto dbd, (database department manager) para poder manejar la base de datos (especificamente para el nombre de los departamentos).
					applicationDeptManager dbd = new applicationDeptManager();
					System.out.println("Connecting...");
					System.out.println(dbd.toString());

					// Usando ResulSet, intenta verificar al usuario.
					ResultSet rsUser = dba.verifyUser(userName, currentPage, previousPage);

					// Revisa si el usuario fue autenticado bien.
					if (rsUser.next()){
						String sessionName = rsUser.getString("name");

						// Crea el attributo currentPage.
						session.setAttribute("currentPage", currentPage);

						// Crea una variable de sesion con el nombre del usuario.
						if (session.getAttribute("userName") == null) {
							session.setAttribute("userName", userName);
						}else{
								// O actualizala.
							session.setAttribute("userName", userName);
						}

						// Recoge el Id del departamento y el nombre del producto.
						String deptName = request.getParameter("dept_name");
						String prodName = request.getParameter("prod_name");

						// Crea un Resulset vacio para poder buscar los productos.
						ResultSet rsProd = null;
						ResultSet rsDept = null;

							// Primero busca si el objeto fue buscado, sin escoger un departamento especifico
					   if  (prodName != null && !prodName.isEmpty() && (deptName == null || deptName.isEmpty() || deptName.equals("SearchAllDepartments"))) {
							rsProd = dbm.listProducts(prodName);
							// Luego, busca si se escogio un nombre y un departamento
						} else if (prodName != null && !prodName.isEmpty() && deptName != null && !deptName.isEmpty() && !deptName.equals("SearchAllDepartments")) {
							rsProd = dbm.listProducts(prodName, deptName);
							// Si no se escogio un nombre, pero si un departamento
						} else if ((prodName == null || prodName.isEmpty()) && deptName != null && !deptName.isEmpty() && !deptName.equals("SearchAllDepartments")) {
							rsProd = dbm.listProducts(null, deptName);
							// Si simplemente le dieron search sin escoger ni escribir nada
						} else if((prodName == null || prodName.isEmpty()) && (deptName == null || deptName.equals("SearchAllDepartments"))) {
							rsProd = dbm.listProducts(null);
						}

                    // Itera sobre el ResultSet dependiendo de los resultados del if/else if
                    int i = 0;

                    while (rsProd.next()) {
                        // cuenta cada uno de los resultados del query
                        i++;
							String deptRealName = "";
							rsDept = dbd.getDepartmentById(rsProd.getInt("dept_id"));
							if (rsDept.next()) {
								deptRealName = rsDept.getString("name");
							}
							rsDept.close();
                        %>
                        <tr>
								<%=rsProd.getString("product_id")%>: <!-- primero coje el ID -->
                            NAME:	<%=rsProd.getString("name")%> <br> <!-- luego, el nombre -->
								<%=rsProd.getString("description")%><br> <!-- luego, la descripcion -->
                            DEPARTMENT: <%=rsProd.getInt("dept_id") + " - " + deptRealName%> <br> <!-- de que departamento es? -->
                            BID: $<%=rsProd.getString("start_bid")%> <br> <!-- cuanto es que esta la paga? -->
						<!-- debi tirar mas fotos -->
                          <img src="/MiniEbay/images/<%= rsProd.getString("picture_path") %>" alt="<%= rsProd.getString("name") %>" width="200"
						  style="max-width:200px; height:auto;"> <br>
                             <form action="displayItem.jsp" method="GET">
                                <!-- guarda la identificacion de forma escondida -->
                                <input type="hidden" name="productId" value="<%=rsProd.getString("product_id")%>">
                                <input type="hidden" name="prodName" value="<%=prodName %>">
                                <input type="hidden" name="dept_name" value="<%=deptName %>">
                                <input type="submit" value="View Item"> <br> <br>
                            </form>
                        </tr>
                    <%}

                    %>
                    </table>

					<form action="welcomeMenu.jsp" method="POST">
                        <button type="submit" name="welcomeMenu" value="welcomeMenu">Return to the main page</button>
                    </form>
                    <%
                }else{
				// Si falla, cierra la sesion con el usuario poniendolo en null.
					session.setAttribute("userName", null);

					// y regresalos a la pagina de login
					response.sendRedirect("loginHashing.html");
                }
				// Cierra la conexion a la base de datos para mantener las cosas limpias.
				dba.close();
				dbm.close();
				dbd.close();
            }
        }catch(Exception e){
			// En caso de que haya un error.
            e.printStackTrace();
            response.sendRedirect("loginHashing.html");

        }finally{
            System.out.println("Finally");
        }
%>
</body>
</html>




