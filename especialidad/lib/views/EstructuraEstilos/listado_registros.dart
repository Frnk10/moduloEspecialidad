import 'package:flutter/material.dart';
import 'dart:io';

class ListadoRegistros extends StatelessWidget {
  // Atributos
  final List elementosFiltrados;
  final TextEditingController buscarController;
  final void Function(int) onInfo;
  final void Function(int) onEditar;
  final void Function(int) onEliminar;
  // Constructor
  const ListadoRegistros({
    super.key,
    required this.elementosFiltrados,
    required this.buscarController,
    required this.onInfo,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(10,10,10,15), //Padding total
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, //Cnetrar horizontalmente los elementos de la row
            children: [
              SizedBox(
                height: 45, //Alto del textfield
                width: MediaQuery.of(context).size.width*0.9, // Ancho dinámico (90% del ancho de la pantalla)
                child: TextField(
                  controller: buscarController, // Utilizar el controlador para la busqueda
                  textCapitalization: TextCapitalization.words, //La primera letra de cada palabra inica en mayuscula
                  autocorrect: true, //Acticar el autocorrector
                  cursorColor: Color.fromARGB(255, 105, 103, 103),
                  decoration: InputDecoration( //Estilos del textfield
                    fillColor: Color.fromRGBO(216, 242, 245, 1), //Color de fondo del textfield
                    filled: true, //Asegura que el color de fondo se aplique
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none, //Ningun borde
                    ),
                    hintText: 'Buscar por nombre, estado ...',
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
            itemCount: elementosFiltrados.length, //Tamaño de la lista
            itemBuilder: (context,indice){
              final item = elementosFiltrados[indice];
              String estado = (int.parse(item.estado.toString())) == 1 ? 'Activo' : 'Inactivo'; //Para el estado activo o inactivo          
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
                            child: item.imagen != null && item.imagen!.isNotEmpty
                            ? ClipOval(
                                child: SizedBox(
                                  height: 100,
                                  width: 70,
                                  child: Image.file( //Para obtener una imagen que viene desde la BDD
                                  File(item.imagen!), //! Se usa el null check solo si no es null
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
                              child: Text(item.titulo,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600) //Estilos del campo nombre en el card
                              ),
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, //Alineacion a la izquierda para elemetos del column
                            children: [
                              Text("Orden: ${item.id}",
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
                                    onPressed: () => onInfo(indice),
                                    tooltip: 'Información',
                                  ),
                                ),
                                Flexible( // BOTON DE ACCION EDITAR
                                  child: IconButton( //Icono editar
                                    icon: Icon(Icons.edit, color: Colors.amber,size:30),
                                    onPressed: () => onEditar(indice),
                                    tooltip: "Editar",
                                  ),
                                ),
                                Flexible( // BOTON TRASH
                                  child: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red,size:30),
                                    onPressed: () => onEliminar(indice) // Boton para eliminar (logico o fisico)
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
        ),
      ],
    );
  }
}