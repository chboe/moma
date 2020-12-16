import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moma_appen/profile.dart';
import 'main.dart';
import 'register.dart';

void main() => runApp(new MyApp());

FlatButton flatButtonHelper(String text, Function goToPage) {
  return new FlatButton(
    child: new Text(
      text,
      style: TextStyle(
        color: Colors.blue,
        fontSize: 14,
      ),
    ),
    onPressed: goToPage,
  );
}

TextField textFieldHelper(String text, bool obscure, TextEditingController controller) {
  return new TextField(
    controller: controller,
    obscureText: obscure,
    decoration: new InputDecoration(
      labelText: text,
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Login',
      theme: new ThemeData(
          primarySwatch: Colors.red
      ),
      home: new LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

// User is either logging in or creating an account
enum FormType {
  login,
  register
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  String _username = "";
  String _password = "";

  _LoginPageState() {
    _usernameFilter.addListener(_usernameListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _usernameListen() {
    _username = _usernameFilter.text;
  }

  void _passwordListen() {
    _password = _passwordFilter.text;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("MoMa"),
      centerTitle: true,
    );
  }

  Widget _buildTextFields() {
    return new Column(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(
            top: 8,
            bottom: 24,
          ),
          child: new Text(
            "Welcome Back",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        textFieldHelper('Username', false, _usernameFilter),
        textFieldHelper('Password', true, _passwordFilter),
      ],
    );
  }

  Widget _buildButtons() {
    return new Padding(
      padding: const EdgeInsets.only(
          top:20
      ),
      child: new Column(
        children: <Widget>[
          new RaisedButton(
            child: new Text('Login'),
            onPressed: _login,
          ),
          new Padding(  //To align black dot with login button
            padding: const EdgeInsets.only(
              left: 16,
            ),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                flatButtonHelper('Forgot Password?', _goToForgotPassword),
                new Container(
                  width: 10,
                  height: 10,
                  decoration: new BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                ),
                flatButtonHelper('Register new account', _goToRegister)
              ],
            ),
          ),
        ],
      ),
    );
  }

  // These functions can self contain any user auth logic required, they all have access to _email and _password
  void _login() async {
    var url = 'http://10.0.2.2:8080/login/$_username/$_password';
    var response = await http.get(url);

    if(response.statusCode==200){
      Profile loggedInAs = Profile.fromJson(jsonDecode(response.body));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(loggedInAs:loggedInAs)
        )
      );
    }

    /*if(_username == "admin") {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => MainPage()
        )
      );
    }*/
  }

  //Not implemented yet
  void _goToRegister() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => RegisterPage()
    ));
  }

  //Not implemented yet
  void _goToForgotPassword() {
    /*Navigator.push(context, MaterialPageRoute(
        builder: (context) => ExampleHomePage()
    ));*/
  }
}