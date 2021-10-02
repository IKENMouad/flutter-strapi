import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_final_fields
  String _username = '';
  // ignore: prefer_final_fields
  String _password = '';
  // ignore: prefer_final_fields
  String _email = '';

  bool _obscureText = true;

  Widget _showUsernameInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        autofocus: true,
        onSaved: (val) => _username = val!,
        validator: (val) {
          String message = '';
          if (val!.isEmpty) {
            message = 'username is required';
          } else if (val.length < 4) {
            message = 'username is least at 4 chars';
          }
          return message.isNotEmpty ? message : null;
        },
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Username',
            hintText: 'Enter username , min length 4',
            icon: Icon(Icons.face, color: Colors.grey)),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _email = val!,
        validator: (val) =>
            val!.isEmpty || !val.contains('@') || !val.contains('.')
                ? 'enter a valid email address'
                : null,
        decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Email',
            hintText: 'Enter valid adress',
            icon: Icon(Icons.email, color: Colors.grey)),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        onSaved: (val) => _password = val!,
        obscureText: _obscureText,
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
              child:
                  Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
              onTap: () => setState(() => _obscureText = !_obscureText),
            ),
            border: const OutlineInputBorder(),
            labelText: 'Password',
            hintText: 'Enter password, min length 8',
            icon: const Icon(Icons.password, color: Colors.grey)),
      ),
    );
  }

  Widget _showFormActions() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => _submitForm(),
            child: const Text(
              'Register',
              style: TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            child: const Text('Existing user? Login'),
          )
        ],
      ),
    );
  }

  _submitForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      registerRequest();
    }
  }

  registerRequest() async {
    try {
      // print('Username: $_username , Email: $_email , Password: $_password');
      const url = 'http://10.0.2.2:3000/auth/register';
      const Map<String, String> headers = {'content-type': 'application/json'};
      final http.Response response = await http.post(Uri.parse(url),
          body: {'name': _username, 'password': _password, 'email': _email},
          headers: headers);
      final responseData = json.decode(response.body);
      print(responseData.toString());
      if (response.statusCode == 201) {
        _showSuccesSnak();
      } else {
        String message = responseData['message'];
        _showFailedSnak(message);
      }
    } catch (e) {
      _showFailedSnak(e.toString());
    }
  }

  void _showSuccesSnak() {
    final snakBar = SnackBar(
      content: Text(
        'User $_username successfully created !',
        style: const TextStyle(color: Colors.green),
      ),
      duration: const Duration(milliseconds: 500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snakBar);
    _formKey.currentState!.reset();
  }

  void _showFailedSnak(String message) {
    final snakBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
      duration: const Duration(milliseconds: 500),
    );
    ScaffoldMessenger.of(context).showSnackBar(snakBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('register'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'Register',
                    ),
                    _showUsernameInput(),
                    _showEmailInput(),
                    _showPasswordInput(),
                    _showFormActions()
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
