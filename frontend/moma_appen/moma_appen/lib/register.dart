import 'package:flutter/material.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage();

  @override
  State<StatefulWidget> createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController pictureController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController passConfirmController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("MoMa"),
        centerTitle: true,
      ),
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


  Widget _buildTextFields() {
    return new Column(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.only(
            top: 16,
            bottom: 24,
          ),
          child: new Text(
            "Register",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ),
        textFieldHelper('Name', false, nameController),
        textFieldHelper('Username', true, usernameController),
        textFieldHelper('Email', false, emailController),
        textFieldHelper('Picture', false, pictureController),
        textFieldHelper('Password', true, passController),
        textFieldHelper('Confirm Password', true, passConfirmController),
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
            child: new Text('Register'),
            onPressed: _register,
          ),
          flatButtonHelper('Already have an account?', _goToLogin),
        ],
      ),
    );
  }

  //NEEDS IMPLEMENTATION: Hook up to server.
  void _register() {

  }

  void _goToLogin() {
    Navigator.pop(context);
  }


}