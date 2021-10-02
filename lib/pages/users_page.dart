import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    final prefes = await SharedPreferences.getInstance();
    var storedUser = prefes.getString('user');
    print(storedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'users',
          style: TextStyle(color: Colors.cyanAccent),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: const Center(
            child: Text('User List'),
          ),
        ),
      ),
    );
  }
}
