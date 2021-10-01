import 'package:flutter/material.dart';

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
          ElevatedButton(
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
      print('  Email: $_email , Password: $_password');
    }
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
