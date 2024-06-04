import 'package:flutter/material.dart';
import 'dart:io';
import 'package:sercatrans/ImagenDetalladaScreen.dart';

class Document {
  final String id;
  final String imagePath;
  final String description;
  final String notes;

  Document({
    required this.id,
    required this.imagePath,
    required this.description,
    required this.notes,
  });
}

class DocumentsScreen extends StatelessWidget {
  final List<Document> documents = [
    Document(
      id: '1',
      imagePath: 'assets/ejemplo1.jpg',
      description: 'Ticket de gasolina del 01/01/2023',
      notes: 'Nota 1',
    ),
    Document(
      id: '2',
      imagePath: 'assets/ejemplo2.jpg',
      description: 'Ticket de gasolina del 02/01/2023',
      notes: 'Nota 2',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Documentos'),
      ),
      body: documents.isEmpty
          ? Center(child: Text('No hay documentos.'))
          : ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final document = documents[index];
                return Card(
                  margin: EdgeInsets.all(10.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    onTap: () {
                      // Aquí puedes manejar lo que sucede cuando se toca un documento
                    },
                    title: Hero(
                      tag: 'hero-${document.id}',
                      child: Image.asset(document
                          .imagePath), // Aquí se carga la imagen usando Image.asset
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          document.description,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(document.notes),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
