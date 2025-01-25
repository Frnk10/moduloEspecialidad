import 'package:especialidad/models/especialidad.dart';
import 'package:especialidad/repositories/Especialidad/especialidad_repository.dart';
import 'package:especialidad/views/Especialidad/NavBar/nav_bar.dart';
import 'package:flutter/material.dart';

class ListadoEspecialidadView extends StatefulWidget {
  const ListadoEspecialidadView({super.key});

  @override
  State<ListadoEspecialidadView> createState() => _ListadoEspecialidadViewState();
}

class _ListadoEspecialidadViewState extends State<ListadoEspecialidadView> {
  final EspecialidadRepository _especialidadRepository = EspecialidadRepository(); //Instanciar la clase para acceder a las funciones de especialidad
  List<Especialidad> _especialidades = []; //Lista vacia donde se cargaran los datos luego
  List<Especialidad> _filtradoEspecialidades = []; // Lista vacia para filtrar los datos
  final _buscarController = TextEditingController(); // variable que atrapa la busqueda

  @override
  void initState(){ //Se ejecuta antes de lanzar la interfaz grafica
    super.initState();
    _cargarEspecialidades();
    _buscarController.addListener(_filtrarEspecialidades); // Escucha el evento de cambio de texto en el campo de busqueda
  }

  // Funcion para cargar los datos de la BDD en la lista vacia
  Future<void> _cargarEspecialidades() async{
    final data = await _especialidadRepository.list(); //Llamando a la funcion listar
    setState((){
      _especialidades = data; // Cargar datos en la lista
      _filtradoEspecialidades = data; // Inicialmente ambas listas son iguales
    });
    // ignore: avoid_print
    print("Especialidades cargadas: ${_especialidades.length}");
  }
  // Funcion para obtener los datos filtrados
  void _filtrarEspecialidades() {
    final query = _buscarController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) { // Si no hay consulta, mostrar todos los datos
        _filtradoEspecialidades = _especialidades; // Restaurar con la lista completa
      } else {
        _filtradoEspecialidades = _especialidades.where((especialidad) { // Mostrar lista con datos filtrados
          final tipo = especialidad.nombreEspe.toLowerCase();
          final estado = especialidad.estadoEspe == 1 ? 'Activo' : 'Inactivo';
          return tipo.contains(query) || estado.contains(query);
        }).toList();
      }
    });
  }
  //Funcion para actualizar el estado de una especialidad
  void _actualizarEstado(int id, int estado) async{
    try{
      if(estado == 0){
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Esta especialidad ya ha sido desactivada')),
        );
      }else{
        final resultado = await _especialidadRepository.updateEstado(id);
        if(resultado>0){
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Estado desactivado exitosamente')),
          );
        }else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No se pudo desactivar la especialidad')),
          );
        }
      }
    }catch (e) {
      // ignore: avoid_print
      print('Error al ejectuar la acción: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al ejecuatar esta acción')),
      );
    }
    _cargarEspecialidades();
  }

  @override
  void dispose() {
    _buscarController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return NavBar(
      appBar: AppBar(
        title: Text(
          "Listado de \nEspecialidades",
          textAlign: TextAlign.center, //Se usa para centrar el texto
        ),
        automaticallyImplyLeading: false //Desactiva la flecha de regreso
      ),
      body: _filtradoEspecialidades.isEmpty
      ? Center(child: Text("No hay registros")) // Mostrar mensaje en la pantalla
      :Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10), //Padding total
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, //Cnetrar horizontalmente los elementos de la row
              children: [
                SizedBox(
                  height: 45, //Alto del textfield
                  width: MediaQuery.of(context).size.width*0.9, // Ancho dinámico (90% del ancho de la pantalla)
                  child: TextField(
                    controller: _buscarController, // Utilizar el controlador para la busqueda
                    textCapitalization: TextCapitalization.words, //La primera letra de cada palabra inica en mayuscula
                    autocorrect: true, //Acticar el autocorrector
                    cursorColor: Color.fromARGB(255, 105, 103, 103),
                    decoration: InputDecoration( //Estilos del textfield
                      fillColor: Color.fromRGBO(216, 242, 245, 1), //Color de fondo del textfield
                      filled: true, //Asegura que el color de fondo se aplique
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none, //Ningun borde
                      ),
                      hintText: 'Buscar por tipo o estado ...',
                      hintStyle: TextStyle(
                        color: Color.fromRGBO(87, 99, 108, 0.5),
                        fontSize: 14
                      ),
                      focusedBorder: OutlineInputBorder( //Quitar el evento al dar clic sobre el textfiel
                        borderSide: BorderSide.none
                      ),
                      suffixIcon: Icon(Icons.search_sharp,size:24), //Estilos del icono
                    ),
                  ),
                ),
              ],
            ),
          ),
          //Lista de Registros
          Expanded(
            child: ListView.builder(
              itemCount: _filtradoEspecialidades.length, //Tamaño de la lista
              itemBuilder: (context,indice){
                final especialidad = _filtradoEspecialidades[indice];
                String estado = (int.parse(especialidad.estadoEspe.toString())) == 1 ? 'Activo' : 'Inactivo'; //Para el estado activo o inactivo          
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
                              // Comprobar que el campo de imagen no sea null ni vacío
                              child: especialidad.imagenEspe != null && especialidad.imagenEspe!.isNotEmpty
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
                              child: SingleChildScrollView( // Scroll horizonal para el titulo
                                scrollDirection: Axis.horizontal,
                                child: Text(especialidad.nombreEspe,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600) //Estilos del campo nombre en el card
                                ),
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Espaciar íconos uniformemente
                                children: [ //Contener varios widgets
                                  Flexible(
                                    child: IconButton(
                                      icon: Icon(Icons.info),
                                      onPressed: () {
                                        // Accion para ver info de la especialidad
                                      },
                                      tooltip: 'Información especialidad',
                                    ),
                                  ),
                                  Flexible(
                                    child: IconButton( //Icono editar
                                      icon: Icon(Icons.edit, color: Colors.amber,size:30),
                                      onPressed: (){
                                        Navigator.pushNamed(
                                          context, '/especialidad/form/',
                                          arguments: especialidad
                                        ).then((value) => _cargarEspecialidades()); // Enviar los datos de la especialidad al form                            
                                      },
                                      tooltip: "Editar especilidad",
                                    ),
                                  ),
                                  Flexible(
                                    child: IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red,size:30),
                                      onPressed: (){
                                        // Mostrar un mensaje de confirmacion antes de ejecutar la accion
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context){
                                            return AlertDialog(
                                              title: Text("Desactivar estado"),
                                              content: Text("¿Está seguro que desea cambiar el estado del registro?"),
                                              actions: <Widget>[
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Color.fromRGBO(46, 154, 172, 1),
                                                    foregroundColor: Colors.white,
                                                  ),
                                                  onPressed: (){
                                                    //Accion para cambiar el estado
                                                    _actualizarEstado(especialidad.id as int, especialidad.estadoEspe as int); // Llamar a la funcion eliminar especialidad
                                                    Navigator.of(context).pop(); // Para cerrar el cuadro de dialogo
                                                  },
                                                  child: Text("Desactivar"),
                                                ),
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    foregroundColor: Colors.white,
                                                  ),
                                                  onPressed: (){
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Cancelar"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      tooltip: "Editar estado especialidad",
                                    ),
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
                Navigator.pushNamed(context,'/especialidad/form/'); //Dirigir al formulario para agregar una especialidad
              },
            ),
          ),
        ],
      ),
      //NAVBAR
      indiceSeleccion: 0, //Indice principal del navBar
      onNavTap: (indice){ //Manejo de clics entre pantallas
        if(indice == 0){
          Navigator.pushNamed(context,'/especialidad/listado/');
        }else if(indice == 1){
          Navigator.pushNamed(context,'/especialidad/form/');
        }
      },
    );
  }
}