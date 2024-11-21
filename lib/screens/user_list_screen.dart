import 'package:consumo_dio/modules/post/datasource/user_model.dart';
import 'package:consumo_dio/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'user_form_screen.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final UserRepository _repository = UserRepository();
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final users = await _repository.fetchUsers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      print('Error al cargar usuarios: $e');
    }
  }

  Future<void> _deleteUser(User user) async {
    try {
      await _repository.deleteUser(user.id!);
      setState(() {
        _users.removeWhere((u) => u.id == user.id);
      });
      print('Usuario eliminado: ${user.toJson()}');
    } catch (e) {
      print('Error al eliminar usuario: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserFormScreen()),
              );
              if (result == true) {
                _loadUsers();
              }
            },
          ),
        ],
      ),
      body: _users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserFormScreen(user: user),
                            ),
                          );
                          if (result == true) {
                            _loadUsers();
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteUser(user),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
