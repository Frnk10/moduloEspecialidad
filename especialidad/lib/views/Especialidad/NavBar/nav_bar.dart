import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  //Atributos
  final AppBar appBar; //Appbar definido en cada pantalla
  final Widget body; //Contenido especifico de cada pantalla
  final Stack? floatingActionButton; //Boton flotante para agregar
  final int indiceSeleccion; //Indice seleccionado en el navBar
  final ValueChanged<int> onNavTap; //Callback para manejar los clics en el NavBar

  //Constructor
  const NavBar({
    super.key,
    required this.appBar,
    required this.body,
    this.floatingActionButton,
    required this.indiceSeleccion,
    required this.onNavTap
  });

  //Funciones
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar, //Parametro appBar
      body:body, //Contenido dinamico de las pantallas
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(46, 154, 172, 1), //Color de fondo del navBar
        currentIndex: indiceSeleccion, //Indice
        onTap: onNavTap, //Manejo de clics
        showSelectedLabels: false, //Para no mostrar los labels debajo los iconos
        showUnselectedLabels: false, //Para no mostrar los labels debajo los iconos
        items: const <BottomNavigationBarItem> [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: Colors.white, size:30), //Icono del principal del navBar
            label: '' //Texto del icono, no habilitado por el show
          ),
          BottomNavigationBarItem(
            label: '', //Texto del icono, no habilitado por el show
            icon: Icon(Icons.medical_services_outlined,color: Colors.white, size:30) //Icono secundario del navBar
          )
        ],
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}