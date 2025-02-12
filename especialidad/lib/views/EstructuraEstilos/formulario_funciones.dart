import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class FormularioFunciones {
  // Definimos el color del cursor como una variable estática
  static final Color colorCursor = Color.fromARGB(255, 105, 103, 103);
  // Método estático para reutilizar los estilos de los TextFields
  static InputDecoration estilosCampoTexto(String labelText, {String? hintText}) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Color.fromRGBO(87, 99, 108, 0.5)),
      hintText: hintText,
      hintStyle: TextStyle(color: Color.fromRGBO(87, 99, 108, 0.5)), //Color del hintText
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(224, 227, 231, 1),
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(224, 227, 231, 1),
          width: 2,
        ),
      ),
      floatingLabelStyle: TextStyle(
        color: Color.fromRGBO(87, 99, 108, 1),
      ),
    );
  }

  // Método estático para el estilo del TextFormField normales
  static TextFormField textFormFieldTipo1(
    TextEditingController controller, // Nombre del controlador
    String labelText, // Nombre del campo
    {int? maxLength, TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator} // Validación opcional
  ) {
    return TextFormField(
      controller: controller, //Controlador para la especialidad
      maxLength: maxLength, // Número máximo de caracteres
      keyboardType: keyboardType, // Tipo de teclado
      textCapitalization: TextCapitalization.sentences, //Primera letra en mayuscula
      autocorrect: true, // Activar autocorrector
      cursorColor: colorCursor, // Color del cursor
      decoration: estilosCampoTexto(labelText), // Usa el método campoTexto para los estilos
      validator: validator, // Validación opcional
    );
  }  
  // Método estático para el estilo del TextFormField Descripcion
  static TextFormField textFormFieldTipo2(
    TextEditingController controller, // Nombre del controlador
    String labelText, // Nombre del campo
    {int? maxLines = 3, int? minLines = 3, int? maxLength, TextInputType keyboardType = TextInputType.text, 
      String? Function(String?)? validator
    } // Validación opcional
  ) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines, // Permite ingresar hasta 3 líneas de texto
      minLines: minLines, // Número mínimo de líneas
      maxLength: maxLength, // Número máximo de caracteres 25
      keyboardType: TextInputType.multiline, // Habilita el salto de línea
      textCapitalization: TextCapitalization.sentences, // Primera letra en mayúscula de cada oración
      autocorrect: true, // Activa el autocorrector
      cursorColor: colorCursor, // Color del cursor de escritura
      decoration: estilosCampoTexto(labelText), // Usa el método campoTexto para los estilos
      validator: validator, // Validación opcional
    );
  }
}

class ImagePickerHelper {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      var status = await Permission.camera.status;
      if (!status.isGranted) {
        status = await Permission.camera.request();
        if (!status.isGranted) return null;
      }
    }

    final XFile? pickedFile = await _imagePicker.pickImage(source: source);
    if (pickedFile == null) return null;

    final File image = File(pickedFile.path);
    return await guardarImagen(image);
  }

  Future<File> guardarImagen(File image) async {
    final localPath = (await getApplicationDocumentsDirectory()).path;
    final fileName = path.basename(image.path);
    final savedImage = File('$localPath/$fileName');
    await savedImage.writeAsBytes(await image.readAsBytes());
    return savedImage;
  }

  void mostrarModal(BuildContext context, Function(File) onImageSelected) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Tomar foto'),
                onTap: () async {
                  Navigator.pop(context);
                  final File? image = await pickImage(ImageSource.camera);
                  if (image != null) onImageSelected(image);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Seleccionar de la galería'),
                onTap: () async {
                  Navigator.pop(context);
                  final File? image = await pickImage(ImageSource.gallery);
                  if (image != null) onImageSelected(image);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}