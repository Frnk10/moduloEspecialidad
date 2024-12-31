import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:especialidad/models/especialidad.dart';
import 'package:especialidad/repositories/Especialidad/especialidad_repository.dart';
import 'package:especialidad/views/Especialidad/NavBar/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; //Importar paquete para seleccionar o tomar foto de una imagen

class EspecialidadNueva extends StatefulWidget {
  const EspecialidadNueva({super.key});

  @override
  State<EspecialidadNueva> createState() => _EspecialidadNuevaState();
}

class _EspecialidadNuevaState extends State<EspecialidadNueva>{
  final _nuevaEspecialidad = GlobalKey<FormState>(); //Clave global: transaccionar datos del formulario
  //Controladores para los campos de especialidad
  final nombreEspeController = TextEditingController();
  final descripcionEspeController = TextEditingController();
  final ordenEspeController = TextEditingController();
  final estadoEspeController = TextEditingController();
  final imagenEspeController = TextEditingController();
  //Cargar imagen
  final ImagePicker _escoger = ImagePicker(); //Paquete para seleccionar imagenes de galeria o camara
  File? _imagen; //Guarda la imagen seleccionada como un objeto File
  //Variable para switch con estado inicial false
  bool estado = true;
  //Color del cursor de escritura
  final _colorCursor = const Color.fromARGB(255, 105, 103, 103);
  // Variable para imagen en base64
  String? base64Imagen;
  //Funcion para aplicar estilos a los textos
  InputDecoration estilosCampoTexto(String labelText) {
    return InputDecoration( //Aplica un borde alrededor del TextField
      labelText: labelText,
      labelStyle: TextStyle(color: Color.fromRGBO(87, 99, 108, 0.5)), //Color del texto
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(224, 227, 231, 1), //Color de la linea de ancho de borde
          width: 2 //Ancho de la linea de borde
        ),
      ),
      focusedBorder: OutlineInputBorder( //Parecido al evento hover para el textfield
        borderSide: BorderSide(
          color: Color.fromRGBO(224, 227, 231, 1), 
          width: 2 
        ),
      ),
      floatingLabelStyle: TextStyle( //Parecido al evento hover para el texto
        color: Color.fromRGBO(87, 99, 108, 1) // Cambia el color del label al enfocar
      ),
    );
  }

  //Función para mostrar la imagen desde base64
  Widget mostrarImagenDesdeBase64(String base64String) {
    Uint8List bytes = base64Decode(base64String); //Decodifica la cadena base64 a Uint8List
    return Image.memory(bytes); //Muestra la imagen con los bytes decodificados
  }

  //Metodo para seleccionar una imagen desde la galeria o camara
  Future<void> _escogerImagen(ImageSource source) async{ //Puede ser ImageSource.camera o ImageSource.gallery y abre la cámara o la galería
    final XFile? escogerFile = await _escoger.pickImage(source: source);
    if(escogerFile != null){ //Validar que sea diferente de nulo
      setState((){
        _imagen = File(escogerFile.path); //Gurdamos la imagen seleccionada
        base64Imagen = base64Encode(_imagen!.readAsBytesSync()); //Convierte la imagen a base64
      });
    }
  }

  void _opcionesSeleccionImagen() { //Funcion para escoger entre tomar una foto o seleccionar una imagen de la galeria
    showModalBottomSheet( //Modal para seleccionar tomar foto o galeria
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Tomar foto'),
                onTap: () {
                  Navigator.pop(context); //Escoger tomar una foto
                  _escogerImagen(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Seleccionar de la galería'),
                onTap: () {
                  Navigator.pop(context); //Seleccionar imagen de la galeria
                  _escogerImagen(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _seccionMostrarImagen() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:30), //Padding de 30 horizontal
      child: InkWell(
        onTap: _opcionesSeleccionImagen, //LLamdo a la funcion para las opciones de carga de imagenes
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0), //Padding alto y ancho
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(224, 227, 231, 1),
              width: 2.0, //Ancho de la linea de borde
            ),
            borderRadius: BorderRadius.circular(8.0), //Borde esquinado de 8
          ),
          child: Column(
            children: [
              if (_imagen != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), //Bordes de la imagen
                  child: Image.file(
                    _imagen!,
                    height: 70, //Alto de la imagen
                    width: 80, //double.infinity, //Ancho de la imagen
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Alinea al centro verticalmente
                children: [
                  Expanded(
                    child: Text(
                      _imagen == null ? 'Cargar imagen' : 'Cambiar imagen', //Si hay una imagen mostrar 'Cambiar' y si no 'Cargar'
                      style: TextStyle(
                        color: Color.fromRGBO(87, 99, 108, 0.5),
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center, //Centrar el texto horizontalmente
                    )
                  ),
                  Icon( //Icono de cargar imagenes
                    Icons.upload_sharp,
                    color: Color.fromRGBO(46, 154, 172, 1),
                    size:30
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Funcion para aplicar estilos en el texto
  
  @override
  Widget build(BuildContext context) {
    return NavBar(
      appBar: AppBar(
        leading:IconButton(
          icon: Icon(Icons.chevron_left,color: Colors.white,size:40.0),
          onPressed: (){
            Navigator.pushNamed(context,'/especialidad/index');
          }, 
        ),            
        title: const Text("CREAR ESPECIALIDAD",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _nuevaEspecialidad, //Asignar clave global al formulario, (token)
          child: ListView(
            children: [
              SizedBox(height:20),
              Text(
                "Especialidad",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
              SizedBox(height:25),
              TextField(
                controller: nombreEspeController, //Controlador para la especialidad
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences, //Primera letra en mayuscula
                autocorrect: true, // Activar autocorrector
                cursorColor: _colorCursor, //Llamado a la variable que tiene el color del cursor de escritura
                decoration: estilosCampoTexto('Nombre de la especialidad'), //Llamado a la funcion con los estilos
              ),
              SizedBox(height: 35),
              TextField(
                controller: descripcionEspeController, //Controlador para la descripcion
                maxLines: 3, //Permite ingresar hasta 3 líneas de texto,
                minLines: 3, //Numero minimo de lineas
                keyboardType: TextInputType.multiline, // Habilita el salto de línea
                textCapitalization: TextCapitalization.sentences, //Primera letra en mayuscula de cada oracion
                autocorrect: true, //Acitva el autocorrector
                cursorColor: _colorCursor , //Color del cursor de escritura
                decoration: estilosCampoTexto('Descripción'), //Llamado a la funcion con los estilos              
              ),
              SizedBox(height:25),
              Row(
                mainAxisAlignment: MainAxisAlignment.start, //Alineación de los elementos en el Row
                children: [
                  Expanded( //Que los elementos ocupen el espacio del row, column o flex
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.center, //Alinea los elementos dentro de la columna a la izquierda
                      children: [
                        Text(
                          "Orden",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height:2),
                        SizedBox(// Para definir el ancho de un textfield
                          width: 100,
                          child: TextField(
                            controller: ordenEspeController, //Controlador para el orden
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            cursorColor: _colorCursor, //Color del cursor de escritura
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(224, 227, 231, 1),
                                  width: 2
                                )
                              ),
                              hintText: 'Número',
                              hintStyle: TextStyle(color: Color.fromRGBO(87, 99, 108, 0.5)), //Color del hintText
                              focusedBorder: OutlineInputBorder( //Efecto hover para borde
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(224, 227, 231, 1),
                                  width: 2
                                )
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width:20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        Text(
                          "Estado",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height:4),
                        Switch(
                          value: estado, //Valor del switch (false) por defecto
                          activeColor: Colors.white, //Color boton cuando esta activa
                          activeTrackColor: const Color.fromRGBO(46, 154, 172, 1), // Color pista cuando esta activada
                          onChanged: (bool newEstado){
                            setState((){
                              estado = newEstado; //Actualiza el estado del switch
                            });
                          }
                        ),
                      ]
                    ),
                  ),
                ],
              ),
              SizedBox(height:35),
              // Seccionar de imagen
              _seccionMostrarImagen(),
              SizedBox(height: 45),
              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () async{
                          if(_nuevaEspecialidad.currentState!.validate()){
                            //Convertir el estado del swu¿itch (true o false) a 1 o 0
                            int estadoEspecialidad = estado ? 1 : 0;
                            //Si la imagen está en base64 y quieres convertirla a Uint8List
                            Uint8List imagen = base64Decode(base64Imagen ?? '');
                            //Obtener la fecha actual para fechaCreacion y fechaActualizacion
                            DateTime fechaActual = DateTime.now();
                            //Objeto con datos recopilados
                            Especialidad especialidad = Especialidad(
                              nombreEspe: nombreEspeController.text,
                              descripcionEspe: descripcionEspeController.text,
                              ordenEspe: int.parse(ordenEspeController.text),
                              estadoEspe: estadoEspecialidad,
                              imagenEspe: imagen,
                              fechaCreacionEspe: fechaActual,
                              fechaActualizacionEspe: fechaActual,
                            );
                            try{
                              var result = await EspecialidadRepository().create(especialidad); //Llamar a la funcion para crear una especialidad
                              // ignore: avoid_print
                              print('El id de la especialidad es: ${result.toString()}');
                              if(context.mounted){
                                Navigator.pushNamed(context,"/especialidad/index"); //Redirige a la ventana principal
                              }
                            }catch(e){
                              // ignore: avoid_print
                              print('Error al crear la especialidad: $e');
                            }
                          }
                        },
                        icon: Icon(Icons.save,color: Colors.white,size: 40),
                        label: Text("Guardar",style: TextStyle(color: Colors.white,fontSize:16,fontWeight: FontWeight.w600)),
                        iconAlignment: IconAlignment.start, //Posicion del icono (izquierdo)
                        style: ElevatedButton.styleFrom(//Estilo para el boton
                          backgroundColor: Color.fromRGBO(73, 182, 199, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                          )
                        )
                      ),
                    )
                  ),
                  SizedBox(width:16),
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: (){
                          Navigator.pushNamed(context,'/especialidad/index');
                        },
                        icon: Icon(Icons.cancel_rounded,size:40),
                        label: Text("Cancelar", style: TextStyle(color: Colors.white,fontSize:16,fontWeight: FontWeight.w600)),
                        iconAlignment: IconAlignment.start, // Posicion del icono al inicio (izquierda)
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(255, 52, 58, 1),
                          iconColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                          )
                        )
                      ),
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      //NavBar
      indiceSeleccion: 0, //Indice principal del navBar
      onNavTap: (indice){
        if(indice == 0){
          Navigator.pushNamed(context,'/especialidad/index');
        }else if(indice == 1){
          Navigator.pushNamed(context,'/especialidad/form');
        }
      },
    );
  }
}


