import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart'; //Importar paquete para seleccionar o tomar foto de una imagen
import 'package:especialidad/models/especialidad.dart';
import 'package:especialidad/repositories/Especialidad/especialidad_repository.dart';
import 'package:especialidad/views/Especialidad/NavBar/nav_bar.dart';

class EspecialidadFormView extends StatefulWidget {
  const EspecialidadFormView({super.key});

  @override
  State<EspecialidadFormView> createState() => _EspecialidadFormViewState();
}

class _EspecialidadFormViewState extends State<EspecialidadFormView>{
  Especialidad? _especialidad; // Declarar clase especialidad
  final _formEspecialidadkey = GlobalKey<FormState>(); //Clave global: transaccionar datos del formulario
  //Controladores para los campos de especialidad
  final nombreEspeController = TextEditingController();
  final descripcionEspeController = TextEditingController();
  final ordenEspeController = TextEditingController();
  bool estado = true; //Variable para switch con estado inicial true
  final imagenEspeController = TextEditingController();
  DateTime fechaCreacion = DateTime.now(); // Definir la fecha creacion
  DateTime fechaActualizacion = DateTime.now(); // Definir la fecha actualizacion
  //Cargar imagen
  final ImagePicker _escoger = ImagePicker(); //Clase que permite seleccionar imagenes de galeria o camara
  File? _imagenSeleccionada; //Guarda la imagen seleccionada como un objeto File
  // Variable para imagen en base64
  String? base64Imagen;
  // Color del cursor de escritura global
  final _colorCursor = const Color.fromARGB(255, 105, 103, 103);

  // FUNCION APLICAR ESTILOS A LOS TEXT, TEXTFIELDS
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
        _imagenSeleccionada = File(escogerFile.path); //Gurdamos la imagen seleccionada
        base64Imagen = base64Encode(_imagenSeleccionada!.readAsBytesSync()); //Convierte la imagen a base64
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
              if (_imagenSeleccionada != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0), //Bordes de la imagen
                  child: Image.file(
                    _imagenSeleccionada!,
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
                      _imagenSeleccionada == null ? 'Cargar imagen' : 'Cambiar imagen', //Si hay una imagen mostrar 'Cambiar' y si no 'Cargar'
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
  
  @override
  Widget build(BuildContext context) {
    _especialidad = ModalRoute.of(context)!.settings.arguments as Especialidad ?; // Atrapar los argumentos de especialidad
    if(_especialidad != null){ // Verificar si especialidad tiene datos
      // Cargar los datos de especialidad a los controladores
      nombreEspeController.text = _especialidad!.nombreEspe;
      descripcionEspeController.text = _especialidad!.descripcionEspe;
      ordenEspeController.text = _especialidad!.ordenEspe.toString();
      estado = _especialidad!.estadoEspe == 1 ? true : false;
      fechaCreacion = _especialidad!.fechaCreacionEspe as DateTime;
    }
    return NavBar(
      appBar: AppBar(
        leading:IconButton(
          icon: Icon(Icons.chevron_left,color: Colors.white,size:40.0),
          onPressed: (){
            Navigator.pushNamed(context,'/especialidad/listado/');
          }, 
        ),            
        title: Text(_especialidad == null ? "Crear Especialidad" : "Actualizar Especialidad", //Verifica y cambia el titulo
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20), // Espacio entre el body y el nav
        child: Form(
          key: _formEspecialidadkey, //Asignar clave global al formulario, (token)
          child: ListView(
            children: [
              Text(
                "Especialidad",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
              SizedBox(height:25),
              TextFormField(
                controller: nombreEspeController, //Controlador para la especialidad
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences, //Primera letra en mayuscula
                autocorrect: true, // Activar autocorrector
                cursorColor: _colorCursor, //Llamado a la variable que tiene el color del cursor de escritura
                decoration: estilosCampoTexto('Nombre de la especialidad'), //Llamado a la funcion con los estilos
              ),
              SizedBox(height: 35), // Espacio entre textfields
              TextFormField(
                controller: descripcionEspeController, //Controlador para la descripcion
                maxLines: 3, //Permite ingresar hasta 3 líneas de texto,
                minLines: 3, //Numero minimo de lineas
                maxLength: 25, // Numero maximo de caracteres
                keyboardType: TextInputType.multiline, // Habilita el salto de línea
                textCapitalization: TextCapitalization.sentences, //Primera letra en mayuscula de cada oracion
                autocorrect: true, //Acitva el autocorrector
                cursorColor: _colorCursor , //Color del cursor de escritura
                decoration: estilosCampoTexto('Descripción'), //Llamado a la funcion con los estilos              
              ),
              SizedBox(height:25),
              Row(
                mainAxisAlignment: MainAxisAlignment.start, //Alineacion de los elementos en el Row
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
                          child: TextFormField(
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
                              _especialidad!.estadoEspe = newEstado ? 1 : 0; // Actualizamos el modelo
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
                          if(_formEspecialidadkey.currentState!.validate()){
                            //Convertir el estado del switch (true o false) a 1 o 0
                            int estadoEspecialidad = estado ? 1 : 0;
                            //Si la imagen está en base64 y quieres convertirla a Uint8List
                            Uint8List? imagen; // Puede ser null
                            if(base64Imagen != null && base64Imagen!.isNotEmpty){
                              imagen = base64Decode(base64Imagen!);
                            }
                            //Objeto con datos recopilados
                            Especialidad especialidad = Especialidad(
                              nombreEspe: nombreEspeController.text,
                              descripcionEspe: descripcionEspeController.text,
                              ordenEspe: int.parse(ordenEspeController.text),
                              estadoEspe: estadoEspecialidad,
                              imagenEspe: imagen,
                              fechaCreacionEspe: fechaCreacion,
                              fechaActualizacionEspe: fechaActualizacion,
                            );
                            int resultado; //Variable para mostrar id de especialidad cuando se crea o actualiza
                            if(_especialidad == null){
                              try{
                                resultado = await EspecialidadRepository().create(especialidad); //Llamar a la funcion para crear una especialidad
                                // ignore: avoid_print
                                print('El id de la especialidad es: ${resultado.toString()}');
                              }catch(e){
                                // ignore: avoid_print
                                print('Error al crear la especialidad: $e');
                              }
                            }else{
                              // Si la espeecialidad ya existe, actualizarla
                              try{
                                especialidad.id = _especialidad!.id;
                                resultado =  await EspecialidadRepository().update(especialidad); //Llamar a la funcion para crear una especialidad
                                // ignore: avoid_print
                                print('El id de la especialidad actualizada: ${resultado.toString()}');
                              }catch(e){
                                // ignore: avoid_print
                                print('Error al actualizar la especialidad: $e');
                              }
                            }
                            if(context.mounted){
                              Navigator.pushNamed(context,'/especialidad/listado/'); //Redirige a la ventana principal
                            }                           
                          }
                        },
                        icon: Icon(Icons.save,color: Colors.white,size: 40),
                        label: Text(_especialidad == null ? "Guardar" : "Aceptar",
                          style: TextStyle(color: Colors.white,fontSize:16,fontWeight: FontWeight.w600)
                        ),
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
                          Navigator.pushNamed(context,'/especialidad/listado/');
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
          Navigator.pushNamed(context,'/especialidad/listado/');
        }else if(indice == 1){
          Navigator.pushNamed(context,'/especialidad/form/');
        }
      },
    );
  }
}


