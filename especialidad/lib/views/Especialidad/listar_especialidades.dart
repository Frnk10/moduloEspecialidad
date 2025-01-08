import 'package:especialidad/models/especialidad.dart';
import 'package:especialidad/repositories/Especialidad/especialidad_repository.dart';
import 'package:especialidad/views/Especialidad/NavBar/nav_bar.dart';
import 'package:flutter/material.dart';

class ListarEspecialidad extends StatefulWidget {
  const ListarEspecialidad({super.key});

  @override
  State<ListarEspecialidad> createState() => _ListarEspecialidadState();
}

class _ListarEspecialidadState extends State<ListarEspecialidad> {
  final EspecialidadRepository _especialidadRepository = EspecialidadRepository(); //Instanciar la clase para acceder a las funciones de especialidad
  List<Especialidad> _especialidades = []; //Lista vacia donde se cargaran los datos luego

  @override
  void initState(){ //Se ejecuta antes de lanzar la interfaz grafica
    super.initState();
    _cargarEspecialidades();
  }

  //Funcion para cargar los datos de la BDD en la lista vacia
  Future<void> _cargarEspecialidades() async{
    final data = await _especialidadRepository.list(); //Llamando a la funcion listar
    setState((){
      _especialidades = data; //Cargar datos en la lista
    });
  }

  //Funcion para actualizar el estado de un registro
  
  @override
  Widget build(BuildContext context) {
    return NavBar(
      appBar: AppBar(
        title: Text(
          "LISTADO DE \nESPECIALIDADES",
          textAlign: TextAlign.center, //Se usa para centrar el texto
        ),
        automaticallyImplyLeading: false //Desactiva la flecha de regreso
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration( //Estilos para el container
          color: Color.fromRGBO(241, 244, 249, 0.5),
          border: Border(
            top: BorderSide( //Borde superior del container
              color: Color.fromRGBO(30, 31, 32, 0.5)
            )
          )
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10), //Padding superior del row
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, //Cnetrar horizontalmente los elementos de la row
                children: [
                  SizedBox(
                    height: 45, //Alto del textfield
                    width: 300, //Ancho del textfield
                    child: TextField(
                      textCapitalization: TextCapitalization.words, //La primera letra de cada palabra inica en mayuscula
                      autocorrect: true, //Acticar el autocorrector
                      cursorColor: Color.fromARGB(255, 105, 103, 103),
                      decoration: InputDecoration( //Estilos del textfield
                        fillColor: Color.fromRGBO(216, 242, 245, 1), //Color de fondo del textfield
                        filled: true, //Asegura que el color de fondo se aplique
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none, //Ningun borde
                        ),
                        hintText: 'Buscar especialidad ...',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(87, 99, 108, 0.5),
                          fontSize: 14
                        ),
                        focusedBorder: OutlineInputBorder( //Quitar el evento al dar clic sobre el textfiel
                          borderSide: BorderSide.none
                        )
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:20),//Separar 20px del lado izquerdo
                    child: Material( //Envolver el iconButton para personalizarlo
                      color: Color.fromRGBO(37, 71, 84, 1), //Color de fondo del iconobutton
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), //Bordes redondeados del iconbutton
                      ),
                      child: SizedBox( //Tamaño del iconButton
                        height: 40,
                        width: 40,
                        child: IconButton(
                          icon: Icon(Icons.search_sharp,size:24,color: Colors.white), //Estilos del icono
                          onPressed: (){
                            //Accion para buscar
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            //Lista de Registros
            Expanded(
              child: _especialidades.isEmpty //Verificar si esta vacia la lista
              ?Center(child: Text("No hay datos")) //Mostrar este mensaje si esta vacia
              :ListView.builder(
                itemCount: _especialidades.length, //Tamaño de la lista
                itemBuilder: (context,indice){
                  final especialidad = _especialidades[indice];
                  String estado = (int.parse(especialidad.estadoEspe.toString()) == 1) ? 'Activo' : 'Inactivo'; //Para el estado activo o inactivo          
                  return Padding(
                    padding: EdgeInsets.all(10), //Padding total para el card
                    child: SizedBox(
                      height: 100,
                      child: Card(
                        elevation: 3, //Sombra debajo del card                  
                        color: Color.fromRGBO(216, 242, 245, 1), //Color de fondo del card,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start, //Asegura que los elementos estén alineados arriba
                          children: [
                            ListTile(
                              leading: Container(
                                child: especialidad.imagenEspe != null //Comprobar que el campo de imagen no sea null
                                ? ClipOval(
                                    child: SizedBox(
                                      height: 100,
                                      width: 70,
                                      child: Image.memory( //Para obtener una imagen que viene desde la BDD
                                        especialidad.imagenEspe!, //! Se usa el null check solo si no es null
                                        height: 110, //Alto de la imagen
                                        width: 90, //Ancho de la imagen
                                        fit: BoxFit.cover,
                                        errorBuilder:(context, error,stackTrace){
                                          return const Center( //Centrar elementos verticalmente
                                            child: Text("Error", //Mensaje de error
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.red))
                                          ); //Si hay un error, se coloca un icon en su lugar
                                        }
                                      )
                                    )
                                  )
                                : const Text("Sin imagen",textAlign: TextAlign.center)//Si no hay imagen, se coloca un icon en su lugar    
                              ),
                              title: Align( //Alineación a la izquierda
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  especialidad.nombreEspe,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600) //Estilos del campo nombre en el card
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start, //Alineacion a la izquierda para elemetos del column
                                children: [
                                  Text("Orden: ${especialidad.ordenEspe}",
                                    style:TextStyle( //Estilos del campo orden en el card
                                      color: Color.fromRGBO(87, 99, 108, 1),
                                      fontSize: 14
                                    )
                                  ),        
                                  Text("Estado: $estado",
                                    style:TextStyle( //Estilos del campo estado en el card
                                      color: Color.fromRGBO(87, 99, 108, 1),
                                      fontSize: 14
                                    )
                                  )
                                ],
                              ),
                              trailing: SizedBox( //Parte izquierda del card para los botones de accion
                                width: 100, //Ancho
                                child: Row(
                                  children: [ //Contener varios widgets
                                    IconButton( //Icono editar
                                      icon: Icon(Icons.edit, color: Colors.amber,size:30),
                                      onPressed: (){},
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red,size:30),
                                      onPressed: (){
                                        //Emitir un mensaje de confirmacion antes de ejecutar la accion
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context){
                                            return AlertDialog(
                                              title: Text("Desactivar estado Activo"),
                                              content: Text("¿Está seguro que desea cambiar el estado del registro?"),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text("Desactivar"),
                                                  onPressed: (){
                                                    //Accion para cambiar el estado
                                                  }
                                                ),
                                                TextButton(
                                                  child: Text("Cancelar"),
                                                  onPressed: (){
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            )
          ],
        ),
      ), 
      floatingActionButton: Stack( //Button flotante para añadir otra especialidad
        children: [
          Positioned(
            bottom: 15, //Espacio parte inferior
            right: 0, //Espacio parte lateral derecha
            child: FloatingActionButton(
              shape: CircleBorder(), //Asegura que el boton sea circular
              elevation: 8,
              backgroundColor: Color.fromRGBO(37, 71, 84, 1), //Color de fondo del boton
              child: Icon(Icons.add,size: 24,color: Colors.white), //Color y tamaño del icono
              onPressed: (){
                Navigator.pushNamed(context,'/especialidad/form'); //Dirigir al formulario para agregar una especialidad
              },
            ),
          ),
        ],
      ),
      //NAVBAR
      indiceSeleccion: 0, //Indice principal del navBar
      onNavTap: (indice){ //Manejo de clics entre pantallas
        if(indice == 0){
          Navigator.pushNamed(context,'/especialidad/index');
        }else if(indice == 1){
          Navigator.pushNamed(context,'/especialidad/form');
        }
      },
    );
  }
}