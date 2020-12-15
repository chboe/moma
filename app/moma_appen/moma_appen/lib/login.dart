import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';


void main() => runApp(new MyApp());

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

  // Swap between register and login forms
  void _formChange() async {

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
    print('The user wants to login with $_username and $_password');

    var url = 'localhost:8080/login/$_username/$_password';
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if(_username == "admin") {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ExampleHomePage()
        )
      );
    }
  }

  void _createAccount() {
    print('The user wants to create an account with $_username and $_password');

  }

  void _passwordReset() {
    print("The user wants a password reset request sent to $_username");
  }

  //Not implemented yet
  void _goToRegister() {
    /*Navigator.push(context, MaterialPageRoute(
        builder: (context) => ExampleHomePage()
    ));*/
  }

  //Not implemented yet
  void _goToForgotPassword() {
    /*Navigator.push(context, MaterialPageRoute(
        builder: (context) => ExampleHomePage()
    ));*/
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

}