import 'package:flutter/material.dart';
import 'package:especialidad/models/especialidad.dart';

class EspecialidadInfoView extends StatelessWidget {
  final Especialidad especialidad; // Recibimos el objeto completo

  const EspecialidadInfoView({
    super.key,
    required this.especialidad, // Constructor recibe el objeto completo
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Información de la Especialidad',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal[700], // Color del encabezado
      ),
      body: Container(
        color: Colors.purple[50], // Color de fondo
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              'Especialidad',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ClipOval(
              child: especialidad.imagenEspe != null
                  ? Image.memory(
                      especialidad.imagenEspe!, // Usamos la imagen en memoria
                      height: 120,
                      width: 120,
                      fit: BoxFit.cover, // Asegura que la imagen se recorte correctamente
                    )
                  : Icon(Icons.image, size: 120), // En caso de que no haya imagen
            ),
            const SizedBox(height: 20),
            _buildInfoCard('Nombre de la Especialidad', especialidad.nombreEspe),
            _buildInfoCard('Descripción', especialidad.descripcionEspe),
            _buildInfoCard('Estado', especialidad.estadoEspe == 1 ? 'Activo' : 'Inactivo'),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal[700],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(value),
      ),
    );
  }
}
