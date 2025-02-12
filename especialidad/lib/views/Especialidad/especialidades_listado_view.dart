import 'package:flutter/material.dart';
import 'package:especialidad/views/EstructuraEstilos/nav_bar.dart'; // NavBar
import 'package:especialidad/views/EstructuraEstilos/listado_registros.dart'; // ListView
import 'package:especialidad/models/especialidad.dart'; // Models
import 'package:especialidad/repositories/Especialidad/especialidad_repository.dart'; // Repository

class EspecialidadListadoView extends StatefulWidget {
  const EspecialidadListadoView({super.key});

  @override
  State<EspecialidadListadoView> createState() => _EspecialidadListadoViewState();
}

class _EspecialidadListadoViewState extends State<EspecialidadListadoView> {
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
  Future _cargarEspecialidades() async{
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
        _filtradoEspecialidades = _especialidades.where((especialidad) { // Consulta segun los datos de filtrado
          final tipo = especialidad.titulo.toLowerCase();
          final estado = especialidad.estado == 1 ? 'Activo' : 'Inactivo';
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

  // Evita que el contrador ocupe memoria cuando ya no se use
  @override
  void dispose() {
    _buscarController.dispose();
    super.dispose();
  }
  // ESTRUCTURA VISUAL
  @override
  Widget build(BuildContext context) {
    return NavBar(
      appBar: AppBar(
        leading:IconButton(
          icon: Icon(Icons.chevron_left,color: Colors.white,size:40.0),
          onPressed: (){
            // DEFINIR RUTA A LA QUE SE REGRESA
          }, 
        ),
        title: Text(
          "Listado de \nEspecialidades",
          textAlign: TextAlign.center, //Se usa para centrar el texto
        ),
        automaticallyImplyLeading: false //Desactiva la flecha de regreso
      ),
      body: _filtradoEspecialidades.isEmpty
      ?Center(child: Text("No hay registros")) // Mostrar mensaje en la pantalla
      :ListadoRegistros( //Lista de Registros
        elementosFiltrados: _filtradoEspecialidades,
        buscarController: _buscarController,
        onInfo: (indice) {
          Navigator.pushNamed(context, '/especialidad/info/',
            arguments: _filtradoEspecialidades[indice] // Enviar solo un objeto
          ) .then((value) => _cargarEspecialidades()); // Enviar los datos de la especialidad al form
        },
        onEditar:(indice){
          Navigator.pushNamed(
            context, '/especialidad/form/',
            arguments: _filtradoEspecialidades[indice] // Enviar solo un objeto
          ).then((value) => _cargarEspecialidades()); // Enviar los datos de la especialidad al form                            
        },
        onEliminar: (indice){
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
                      int id = _filtradoEspecialidades[indice].id as int;
                      int estado = _filtradoEspecialidades[indice].estado as int;
                      _actualizarEstado(id, estado); // Llamar a la funcion eliminar especialidad
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
        }
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
              child: Icon(Icons.add,color: Colors.white,size: 24), //Color y tamaño del icono
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