import 'dart:async';
import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:mongo_dart/mongo_dart.dart';

void main() async {
  final db = Db('mongodb://localhost:27017/App_prueba');
  await db.open();
  final usersCollection = db.collection('Cuentas');

  final app = Router();

  // Endpoint para registrar usuario
  app.post('/register', (Request request) async {
    final payload = await request.readAsString();
    final data = json.decode(payload) as Map<String, dynamic>;
    final hashedPassword =
        data['password']; // Aquí podrías agregar hash de contraseña
    await usersCollection
        .insertOne({'email': data['email'], 'password': hashedPassword});
    return Response.ok('User registered');
  });

  // Endpoint para iniciar sesión
  app.post('/login', (Request request) async {
    final payload = await request.readAsString();
    final data = json.decode(payload) as Map<String, dynamic>;
    final user = await usersCollection.findOne({'email': data['email']});
    if (user != null && user['password'] == data['password']) {
      // Aquí podrías generar un token JWT
      return Response.ok(json.encode({'message': 'Login successful'}));
    } else {
      return Response(401, body: 'Invalid credentials');
    }
  });

  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(app);

  final server = await io.serve(handler, 'localhost', 8080);
  print('Server listening on port ${server.port}');
}
