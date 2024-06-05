import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;
import 'ImagenDetalladaScreen.dart';
import 'documents_screen.dart';
import 'package:gallery_saver/gallery_saver.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Screen'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                if (_controller != null && _controller!.value.isInitialized)
                  CameraPreview(_controller!),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    onPressed: _takePicture,
                    child: Icon(Icons.camera),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final rearCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => throw Exception('No se encontró la cámara trasera'),
      );
      _controller = CameraController(rearCamera, ResolutionPreset.medium);
      _initializeControllerFuture = _controller!.initialize();
      setState(() {});
    } catch (e) {
      print('Error al inicializar la cámara: $e');
    }
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;

      final directory = await getTemporaryDirectory();
      final path = join(
        directory.path,
        '${DateTime.now().millisecondsSinceEpoch}.png',
      );

      XFile picture = await _controller!.takePicture();
      await picture.saveTo(path);

      await GallerySaver.saveImage(path);
      print('Imagen guardada en la galería: $path');

      final newDocument = Document(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imagePath: path,
        description: '',
        notes: '',
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageDetailsScreen(document: newDocument),
        ),
      );
    } catch (e) {
      print('Error al tomar la foto: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al tomar la foto')),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
