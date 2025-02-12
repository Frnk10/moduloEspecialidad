import 'package:flutter/material.dart';
import 'dart:io';
import 'package:especialidad/models/especialidad.dart';
import 'package:especialidad/views/EstructuraEstilos/nav_bar.dart';

class EspecialidadInfoView extends StatefulWidget {
   const EspecialidadInfoView({super.key});

  @override
  State<EspecialidadInfoView> createState() => _EspecialidadInfoViewState();
}
class _EspecialidadInfoViewState extends State<EspecialidadInfoView> {
  Especialidad? _especialidad;
  @override
  Widget build(BuildContext context) {
    _especialidad = ModalRoute.of(context)!.settings.arguments as Especialidad?;
    return NavBar(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left,color: Colors.white,size: 40.0,),
          onPressed: (){
            Navigator.pushNamed(context, '/especialidad/listado/');
          }, 
        ),
        title: const Text(
          'Información de la\nEspecialidad',
           textAlign: TextAlign.center, //Se usa para centrar el texto
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _especialidad != null
            ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Especialidad',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                    ),
                  ),
                  SizedBox(height: 20),
                  _especialidad!.imagen != null && _especialidad!.imagen!.isNotEmpty
                  ?CircleAvatar(
                    radius: 60,
                    backgroundImage: FileImage(File(_especialidad!.imagen!)),
                    backgroundColor: Colors.grey[300],
                  )
                  :CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.image_not_supported,size: 60, color: Colors.grey[600],),
                  ),
                  SizedBox(height: 25),
                  _buildInfoBox('Nombre de la Especialidad', _especialidad!.titulo),
                  _buildInfoBox('Descripción', _especialidad!.descripcion),
                  _buildInfoBox('Estado', _especialidad!.estado == 1 ? 'Activo' : 'Inactivo'),
                ],
              ),
            )
        :Center(
          child: CircularProgressIndicator(),
        )
      ),
      indiceSeleccion: 0,
      onNavTap: (indice) {
        if (indice == 0) {
          Navigator.pushNamed(context, '/especialidad/listado/');
        } else if (indice == 1) {
          Navigator.pushNamed(context, '/especialidad/form/');
        }
      },
    );
  }
  // Funcion para construir cada caja de informacion
  Widget _buildInfoBox(String label, String value) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
