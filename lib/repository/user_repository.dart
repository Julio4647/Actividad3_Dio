import 'package:consumo_dio/modules/post/datasource/user_model.dart';
import 'package:dio/dio.dart';

class UserRepository {
  final Dio _dio =
      Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));

  Future<List<User>> fetchUsers() async {
    final response = await _dio.get('/users');
    return (response.data as List).map((json) => User.fromJson(json)).toList();
  }

  Future<User> fetchUserById(int id) async {
    final response = await _dio.get('/users/$id');
    return User.fromJson(response.data);
  }

  Future<void> createUser(User user) async {
    try {
      final response = await _dio.post(
          'https://jsonplaceholder.typicode.com/users',
          data: user.toJson());
      if (response.statusCode == 201) {
        print('Usuario registrado: ${response.data}');
      } else {
        print('Error al registrar usuario: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al registrar usuario: $e');
    }
  }

  Future<User> updateUser(User user) async {
    print('Actualizando usuario con ID: ${user.id}');
    print('Datos a actualizar: ${user.toJson()}');
    final response = await _dio.put('/users/${user.id}', data: user.toJson());
    print('Usuario actualizado con ID: ${user.id}');
    print('Datos actualizados: ${response.data}');

    return User.fromJson(response.data);
  }

  Future<void> deleteUser(int id) async {
    try {
      final response =
          await _dio.delete('https://jsonplaceholder.typicode.com/users/$id');
      if (response.statusCode == 200) {
        print('Usuario eliminado con éxito: ID $id');
      } else {
        print('Error al eliminar usuario: ${response.statusCode}');
        throw Exception('Error al eliminar usuario');
      }
    } catch (e) {
      print('Error al eliminar usuario: $e');
      throw e;
    }
  }
}
