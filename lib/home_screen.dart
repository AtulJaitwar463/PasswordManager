
import 'package:authorizedapp/add_edit_password_screen.dart';
import 'package:authorizedapp/password_details_screen.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _passwords = [];

  @override
  void initState() {
    super.initState();
    _loadPasswords();
  }

  void _loadPasswords() async {
    var passwords = await DatabaseHelper().getPasswords();
    setState(() {
      _passwords = passwords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Manager'),
      ),
      body: _passwords.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _passwords.length,
        itemBuilder: (context, index) {
          var password = _passwords[index];
          return ListTile(
            title: Text(password['account_type']),
            subtitle: Text('*******'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      //PasswordDetailDialog(id: password['id'])
                      PasswordDetailScreen(id: password['id']),
                ),
              ).then((_) => _loadPasswords());
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => AddEditPasswordScreen(
              onPasswordAdded: () {
                _loadPasswords();
              },
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
