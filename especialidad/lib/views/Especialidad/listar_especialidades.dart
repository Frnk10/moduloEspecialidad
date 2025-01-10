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
  final EspecialidadRepository _especialidadRepository = EspecialidadRepository();
  List<Especialidad> _especialidades = [];

  @override
  void initState() {
    super.initState();
    _cargarEspecialidades();
  }

  Future<void> _cargarEspecialidades() async {
    final data = await _especialidadRepository.list();
    setState(() {
      _especialidades = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavBar(
      appBar: AppBar(
        title: Text(
          "LISTADO DE \nESPECIALIDADES",
          textAlign: TextAlign.center,
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Color.fromRGBO(241, 244, 249, 0.5),
          border: Border(
            top: BorderSide(
              color: Color.fromRGBO(30, 31, 32, 0.5)
            )
          )
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 45,
                    width: 300,
                    child: TextField(
                      textCapitalization: TextCapitalization.words,
                      autocorrect: true,
                      cursorColor: Color.fromARGB(255, 105, 103, 103),
                      decoration: InputDecoration(
                        fillColor: Color.fromRGBO(216, 242, 245, 1),
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Buscar especialidad ...',
                        hintStyle: TextStyle(
                          color: Color.fromRGBO(87, 99, 108, 0.5),
                          fontSize: 14
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none
                        )
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Material(
                      color: Color.fromRGBO(37, 71, 84, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: IconButton(
                          icon: Icon(Icons.search_sharp, size: 24, color: Colors.white),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: _especialidades.isEmpty
                ? Center(child: Text("No hay datos"))
                : ListView.builder(
                    itemCount: _especialidades.length,
                    itemBuilder: (context, indice) {
                      final especialidad = _especialidades[indice];
                      String estado = (especialidad.estadoEspe == 1) ? 'Activo' : 'Inactivo';
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: SizedBox(
                          height: 100,
                          child: Card(
                            elevation: 3,
                            color: Color.fromRGBO(216, 242, 245, 1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ListTile(
                                  leading: Container(
                                    child: especialidad.imagenEspe != null
                                      ? ClipOval(
                                          child: SizedBox(
                                            height: 100,
                                            width: 70,
                                            child: Image.memory(
                                              especialidad.imagenEspe!,
                                              height: 110,
                                              width: 90,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return const Center(
                                                  child: Text(
                                                    "Error",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(color: Colors.red)
                                                  ),
                                                );
                                              }
                                            )
                                          )
                                        )
                                      : const Text("Sin imagen", textAlign: TextAlign.center)
                                  ),
                                  title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      especialidad.nombreEspe,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Orden: ${especialidad.ordenEspe}",
                                        style: TextStyle(
                                          color: Color.fromRGBO(87, 99, 108, 1),
                                          fontSize: 14
                                        )
                                      ),
                                      Text("Estado: $estado",
                                        style: TextStyle(
                                          color: Color.fromRGBO(87, 99, 108, 1),
                                          fontSize: 14
                                        )
                                      )
                                    ],
                                  ),
                                  trailing: SizedBox(
                                    width: 100,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit, color: Colors.amber, size: 30),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red, size: 30),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Desactivar estado"),
                                                  content: Text("¿Está seguro que desea cambiar el estado del registro?"),
                                                  actions: <Widget>[
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        TextButton(
                                                          child: Text("Desactivar"),
                                                          style: TextButton.styleFrom(
                                                            backgroundColor: Color.fromRGBO(73, 182, 199, 1),
                                                            foregroundColor: Colors.white,
                                                          ),
                                                          onPressed: () async {
                                                            int nuevoEstado = especialidad.estadoEspe == 1 ? 0 : 1;
                                                            try {
                                                              await _especialidadRepository.updateEstado(especialidad.id!, nuevoEstado);
                                                              setState(() {
                                                                especialidad.estadoEspe = nuevoEstado;
                                                              });
                                                              Navigator.of(context).pop();
                                                            } catch (e) {
                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al cambiar el estado')));
                                                            }
                                                          },
                                                        ),
                                                        SizedBox(width: 10),
                                                        TextButton(
                                                          child: Text("Cancelar"),
                                                          style: TextButton.styleFrom(
                                                            backgroundColor: Color.fromRGBO(255, 52, 58, 1),
                                                            foregroundColor: Colors.white,
                                                          ),
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                        ),
                                                      ],
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
                  ),
            ),
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 15,
            right: 0,
            child: FloatingActionButton(
              shape: CircleBorder(),
              elevation: 8,
              backgroundColor: Color.fromRGBO(37, 71, 84, 1),
              child: Icon(Icons.add, size: 24, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/especialidad/form');
              },
            ),
          ),
        ],
      ),
      indiceSeleccion: 0,
      onNavTap: (indice) {
        if (indice == 0) {
          Navigator.pushNamed(context, '/especialidad/index');
        } else if (indice == 1) {
          Navigator.pushNamed(context, '/especialidad/form');
        }
      },
    );
  }
}
