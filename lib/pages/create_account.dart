import 'dart:async';

import 'package:fbsocialmediaapp/widgets/header.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _username;

  _submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      final SnackBar snackbar = SnackBar(
        backgroundColor: Colors.green[700],
        content: Text('Bem-vindo, ${_username}', style: TextStyle(color: Colors.white),),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
      Timer(Duration(seconds: 2), (){
        Navigator.pop(context, _username);
      });
      
    }
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, titleText: 'Configure seu perfil', removeBackButton: true),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Center(
                    child: Text(
                      'Crie um nome de usuário',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: TextFormField(
                        validator: (val) {
                          if (val.trim().length < 3 || val.isEmpty) {
                            return 'Username muito curto';
                          } else if (val.trim().length > 12) {
                            return 'Username muito longo!';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (val) => _username = val,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                          labelStyle: TextStyle(fontSize: 15),
                          hintText: 'O nome precisa ter 3 ou mais caracters',
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _submit,
                  child: Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Text(
                        'Salvar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
