import 'package:flutter/foundation.dart';
import 'dart:io';

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

class DocumentModel extends ChangeNotifier {
  List<Document> _documents = [];

  List<Document> get documents => _documents;

  void addDocument(Document document) {
    _documents.add(document);
    notifyListeners();
  }
}
