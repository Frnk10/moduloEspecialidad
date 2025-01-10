import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:especialidad/models/especialidad.dart';
import 'package:especialidad/repositories/Especialidad/especialidad_repository.dart';
import 'package:especialidad/views/Especialidad/NavBar/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EspecialidadActualizar extends StatefulWidget {
  final int idEspecialidad; 
  const EspecialidadActualizar({super.key, required this.idEspecialidad});

  @override
  State<EspecialidadActualizar> createState() => _EspecialidadActualizarState();
}

class _EspecialidadActualizarState extends State<EspecialidadActualizar> {
  final _nuevaEspecialidad = GlobalKey<FormState>(); 
  // Controladores para los campos de especialidad
  final nombreEspeController = TextEditingController();
  final descripcionEspeController = TextEditingController();
  final ordenEspeController = TextEditingController();
  final estadoEspeController = TextEditingController();
  final imagenEspeController = TextEditingController();
  // Cargar imagen
  final ImagePicker _escoger = ImagePicker();
  File? _imagen;
  bool estado = true;
  String? base64Imagen;
  final _colorCursor = const Color.fromARGB(255, 105, 103, 103);

  @override
  void initState() {
    super.initState();
    _cargarEspecialidad();
  }

  // Método para cargar los datos de la especialidad existente
  Future<void> _cargarEspecialidad() async {
    try {
      Especialidad especialidad = await EspecialidadRepository().getById(widget.idEspecialidad);
      nombreEspeController.text = especialidad.nombreEspe;
      descripcionEspeController.text = especialidad.descripcionEspe;
      ordenEspeController.text = especialidad.ordenEspe.toString();
      estado = especialidad.estadoEspe == 1; // Convertir el estado de 1/0 a true/false
      base64Imagen = base64Encode(especialidad.imagenEspe); // Guardar imagen en base64
      setState(() {
        _imagen = File.fromRawPath(especialidad.imagenEspe); // Mostrar la imagen
      });
    } catch (e) {
      // Manejar error si la especialidad no se encuentra
      print('Error al cargar la especialidad: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavBar(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white, size: 40.0),
          onPressed: () {
            Navigator.pushNamed(context, '/especialidad/index');
          },
        ),
        title: const Text(
          "ACTUALIZAR ESPECIALIDAD",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _nuevaEspecialidad,
          child: ListView(
            children: [
              SizedBox(height: 20),
              Text(
                "Especialidad",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28.0),
              ),
              SizedBox(height: 25),
              TextField(
                controller: nombreEspeController,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                cursorColor: _colorCursor,
                decoration: _estilosCampoTexto('Nombre de la especialidad'),
              ),
              SizedBox(height: 35),
              TextField(
                controller: descripcionEspeController,
                maxLines: 3,
                minLines: 3,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                cursorColor: _colorCursor,
                decoration: _estilosCampoTexto('Descripción'),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Orden",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 2),
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: ordenEspeController,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            cursorColor: _colorCursor,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(224, 227, 231, 1), width: 2),
                              ),
                              hintText: 'Número',
                              hintStyle: TextStyle(color: Color.fromRGBO(87, 99, 108, 0.5)),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromRGBO(224, 227, 231, 1), width: 2),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Estado",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Switch(
                          value: estado,
                          activeColor: Colors.white,
                          activeTrackColor: Color.fromRGBO(46, 154, 172, 1),
                          onChanged: (bool newEstado) {
                            setState(() {
                              estado = newEstado;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 35),
              _seccionMostrarImagen(),
              SizedBox(height: 45),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          if (_nuevaEspecialidad.currentState!.validate()) {
                            int estadoEspecialidad = estado ? 1 : 0;
                            Uint8List imagen = base64Decode(base64Imagen ?? '');
                            DateTime fechaActual = DateTime.now();
                            Especialidad especialidad = Especialidad(
                              idEspe: widget.idEspecialidad, // Agregar ID de la especialidad
                              nombreEspe: nombreEspeController.text,
                              descripcionEspe: descripcionEspeController.text,
                              ordenEspe: int.parse(ordenEspeController.text),
                              estadoEspe: estadoEspecialidad,
                              imagenEspe: imagen,
                              fechaCreacionEspe: fechaActual,
                              fechaActualizacionEspe: fechaActual,
                            );
                            try {
                              await EspecialidadRepository().update(especialidad); // Llamar a la función para actualizar la especialidad
                              if (context.mounted) {
                                Navigator.pushNamed(context, "/especialidad/index");
                              }
                            } catch (e) {
                              print('Error al actualizar la especialidad: $e');
                            }
                          }
                        },
                        icon: Icon(Icons.save, color: Colors.white, size: 40),
                        label: Text("Guardar", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        iconAlignment: IconAlignment.start,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(73, 182, 199, 1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/especialidad/index');
                        },
                        icon: Icon(Icons.cancel_rounded, size: 40),
                        label: Text("Cancelar", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                        iconAlignment: IconAlignment.start,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(255, 52, 58, 1),
                          iconColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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

  // Función para aplicar estilos en el texto
  InputDecoration _estilosCampoTexto(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Color.fromRGBO(87, 99, 108, 0.5)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(224, 227, 231, 1), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromRGBO(224, 227, 231, 1), width: 2),
      ),
      floatingLabelStyle: TextStyle(color: Color.fromRGBO(87, 99, 108, 1)),
    );
  }

  // Función para mostrar imagen desde base64
  Widget _seccionMostrarImagen() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: InkWell(
        onTap: _opcionesSeleccionImagen,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Color.fromRGBO(224, 227, 231, 1), width: 2.0),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: [
              if (_imagen != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.file(
                    _imagen!,
                    height: 70,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      _imagen == null ? 'Cargar imagen' : 'Cambiar imagen',
                      style: TextStyle(
                        color: Color.fromRGBO(87, 99, 108, 0.5),
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Icon(
                    Icons.upload_sharp,
                    color: Color.fromRGBO(46, 154, 172, 1),
                    size: 30,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para seleccionar una imagen desde la galería o la cámara
  Future<void> _escogerImagen(ImageSource source) async {
    final XFile? escogerFile = await _escoger.pickImage(source: source);
    if (escogerFile != null) {
      setState(() {
        _imagen = File(escogerFile.path);
        base64Imagen = base64Encode(_imagen!.readAsBytesSync());
      });
    }
  }

  void _opcionesSeleccionImagen() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Tomar foto'),
                onTap: () {
                  Navigator.pop(context);
                  _escogerImagen(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Seleccionar de la galería'),
                onTap: () {
                  Navigator.pop(context);
                  _escogerImagen(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
