



import 'package:flutter/material.dart';
import 'database_helper.dart';

class AddEditPasswordScreen extends StatefulWidget {
  final int? id;
  final VoidCallback onPasswordAdded;

  AddEditPasswordScreen({this.id, required this.onPasswordAdded});

  @override
  _AddEditPasswordScreenState createState() => _AddEditPasswordScreenState();
}

class _AddEditPasswordScreenState extends State<AddEditPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _accountType;
  String? _username;
  String? _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // This will prevent keyboard overlay
      appBar: AppBar(
        title: Text(widget.id == null ? 'Add Account' : 'Edit Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Account Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter account name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _accountType = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Username/ Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username/email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    if (widget.id == null) {
                      DatabaseHelper().addPassword(_accountType!, _username!, _password!).then((_) {
                        widget.onPasswordAdded();
                        Navigator.pop(context);
                      });
                    } else {
                      DatabaseHelper().updatePassword(widget.id!, _accountType!, _username!, _password!).then((_) {
                        widget.onPasswordAdded();
                        Navigator.pop(context);
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Set background color to black
                ),
                child: Text(widget.id == null ? 'Add New Account'  : 'Update Account',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
