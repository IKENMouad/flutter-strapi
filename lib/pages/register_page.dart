import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;

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
      registerRequest()
      print('Username: $_username , Email: $_email , Password: $_password');
    }
  }

  registerRequest(){
          http.post('http://localhost:1337/auth/local/register', { 
          username:_username, 
          password:_password,
          email:_email  
          }  )
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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
