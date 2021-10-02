import 'package:app1/models/app_state.dart';
import 'package:app1/pages/login_page.dart';
import 'package:app1/pages/register_page.dart';
import 'package:app1/pages/users_page.dart';
import 'package:app1/redux/reducers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() {
  final store = Store<AppState>(appReducer,
      initialState: AppState.intial(), middleware: [thunkMiddleware]);
  runApp(MyApp(store));
}

class MyApp extends StatelessWidget {
  MyApp(store);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo 1',
        debugShowCheckedModeBanner: false,
        routes: {
          '/login': (BuildContext context) => const LoginPage(),
          '/register': (BuildContext context) => const RegisterPage(),
          '/users': (BuildContext context) => const UsersPage(),
        },
        theme: ThemeData(
            primaryColor: Colors.cyan[400],
            brightness: Brightness.dark,
            textTheme: const TextTheme(
                headline1:
                    TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold))),
        // home: const RegisterPage()
        home: const UsersPage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
