import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:typed_data/typed_data.dart' as typed;
import 'dart:convert';
import 'documents_screen.dart';

class ImageDetailsScreen extends StatelessWidget {
  final Document document;

  ImageDetailsScreen({required this.document});

  Future<void> enviarMensajeMQTT(BuildContext context, String imagePath,
      String descripcion, String notas) async {
    final MqttServerClient client =
        MqttServerClient('57.128.108.169', 'flutter_client');

    client.port = 1883;
    client.logging(on: true);
    client.keepAlivePeriod = 20;

    final MqttConnectMessage connectMessage = MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .startClean()
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connectMessage;

    String message;
    bool success = false;

    try {
      await client.connect('soidem', 'soidem.mqtt');
      print('Conectado al broker');

      final File file = File(imagePath);
      final Uint8List imageData = await file.readAsBytes();

      final Map<String, dynamic> data = {
        'imagen': base64Encode(imageData),
        'descripcion': descripcion,
        'notas': notas,
      };

      final String jsonData = jsonEncode(data);

      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addUTF8String(jsonData);

      client.publishMessage('sercatrans', MqttQos.atMostOnce, builder.payload!);
      print('Mensaje enviado');
      message = 'Se ha enviado correctamente';
      success = true;
    } catch (e) {
      print('Error al conectar/enviar mensaje: $e');
      message = 'Error al enviar mensaje: $e';
    }

    client.disconnect();
    print('Desconectado');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Resultado del envío',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              success
                  ? SizedBox(
                      width: 70,
                      height: 70,
                      child: Image.asset(
                        'assets/correcto.png',
                      ),
                    )
                  : SizedBox(),
              SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: success ? 18.0 : 16.0,
                  color: success ? Colors.green : Colors.red,
                  fontFamily: 'Roboto',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey[800],
                  ),
                  child: TextButton(
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController descripcionController =
        TextEditingController(text: document.description);
    TextEditingController notasController =
        TextEditingController(text: document.notes);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Imagen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: 'hero-${document.id}',
                child: Image.file(File(document.imagePath)),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: descripcionController,
                  decoration: InputDecoration(
                    labelText: 'Km',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextField(
                  controller: notasController,
                  decoration: InputDecoration(
                    labelText: 'Notas',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    enviarMensajeMQTT(
                      context,
                      document.imagePath,
                      descripcionController.text,
                      notasController.text,
                    );
                  },
                  child: Text('Enviar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
