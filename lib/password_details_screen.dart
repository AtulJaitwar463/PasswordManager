
import 'package:authorizedapp/add_edit_password_screen.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';


class PasswordDetailScreen extends StatelessWidget {
  final int id;

  PasswordDetailScreen({required this.id});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: DatabaseHelper().getPassword(id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Account Details'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Account Details'),
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else {
          var password = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Text('Account Details'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: password['account_type'],
                    decoration: InputDecoration(labelText: 'Account Name'),
                    readOnly: true,
                  ),
                  TextFormField(
                    initialValue: password['username'],
                    decoration: InputDecoration(labelText: 'Username/ Email'),
                    readOnly: true,
                  ),
                  TextFormField(
                    initialValue: password['password'],
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    readOnly: true,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEditPasswordScreen(
                                id: id,
                                onPasswordAdded: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black, // Set background color to black
                        ),
                        child: Text('Edit',style: TextStyle(color: Colors.white),),
                      ),
                      SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          DatabaseHelper().deletePassword(id).then((_) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text('Delete',style: TextStyle(color: Colors.white),),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
