import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // ignore: prefer_final_fields
  String _password = '';
  // ignore: prefer_final_fields
  String _email = '';
  bool _isSubmitted = false;
  bool _obscureText = true;

  Widget _showEmailInput() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: TextFormField(
        autofocus: true,
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
          _isSubmitted == true
              ? CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor))
              : ElevatedButton(
                  onPressed: () => _submitForm(),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.cyan),
                  ),
                ),
          TextButton(
            onPressed: () =>
                Navigator.pushReplacementNamed(context, '/register'),
            child: const Text('Dont have an Acount? Register'),
          )
        ],
      ),
    );
  }

  _submitForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      _loginRequest();
    }
  }

  void _loginRequest() async {
    try {
      setState(() => _isSubmitted = true);
      const url = 'http://10.0.2.2:3000/auth/login';
      const Map<String, String> headers = {'content-type': 'application/json'};
      final http.Response response = await http.post(Uri.parse(url),
          body: json.encode({'password': _password, 'email': _email}),
          headers: headers);
      final responseData = json.decode(response.body);
      setState(() => _isSubmitted = false);
      if (response.statusCode == 200) {
        _storeUserData(responseData);
        _showSuccesSnak();
        _redirectPage();
      } else {
        String message = responseData['message'];
        _showFailedSnak(message);
      }
    } catch (e) {
      _showFailedSnak(e.toString());
    }
  }

  void _storeUserData(userData) async {
    final prefes = await SharedPreferences.getInstance();
    dynamic currentUser = {
      "token": userData['token'],
      "id": userData['id'],
      "name": userData['name'],
      "email": userData['email']
    };
    prefes.setString('user', currentUser.toString());
  }

  void _showSuccesSnak() {
    const snakBar = SnackBar(
      content: Text(
        'You\'re Logged in !',
        style: TextStyle(color: Colors.green),
      ),
      duration: Duration(milliseconds: 500),
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

  void _redirectPage() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/users');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
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
                      'Login',
                    ),
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
