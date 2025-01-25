import 'package:especialidad/views/Especialidad/NavBar/nav_bar.dart';
import 'package:flutter/material.dart';

class EspecialidadInfoView extends StatefulWidget {
  const EspecialidadInfoView({super.key});

  @override
  State<EspecialidadInfoView> createState() => _EspecialidadInfoViewState();
}

class _EspecialidadInfoViewState extends State<EspecialidadInfoView>{
  @override
  Widget build(BuildContext context){
    return NavBar(
      appBar: AppBar(
        leading:IconButton(
          icon: Icon(Icons.chevron_left,color: Colors.white,size:40.0),
          onPressed: (){
            Navigator.pushNamed(context,'/especialidad/listado/');
          }, 
        ),            
        title: Text("Información de \nla Especialidad",
        textAlign: TextAlign.center, //Se usa para centrar el texto
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        automaticallyImplyLeading: false, //Desactiva la flecha de regreso
      ),
      body: Center(child: Text("AQUÍ VA LA INFORMACIÓN")),
      //NavBar
      indiceSeleccion: 0, //Indice principal del navBar
      onNavTap: (indice){
        if(indice == 0){
          Navigator.pushNamed(context,'/especialidad/listado/');
        }else if(indice == 1){
          Navigator.pushNamed(context,'/especialidad/form/');
        }
      },

    );
  }
}