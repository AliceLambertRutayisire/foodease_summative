import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/students/Feedback/feedback2.dart';
import '../main.dart';
import 'Sign up and login/studentlogin.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? '';

    return Drawer(
      backgroundColor: Color.fromRGBO(201, 199, 126, 1),
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(50, 41, 57, 1),
            ),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(
                'assets/images/profile.jpg',
              ),
            ), accountName: Text('Customer Dashboard'),
          ),

          ListTile(
            leading: Icon(Icons.dashboard,  color: Color.fromRGBO(50, 41, 57, 1)),
            title: Text('Order Food'),
            onTap: () {
               Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Color.fromRGBO(50, 41, 57, 1)),
            title: Text('Logout'),
            onTap: () {
               Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StudentLogin()));
            },
          ),
          ListTile(
            leading: Icon(Icons.feedback, color: Color.fromRGBO(50, 41, 57, 1)),
            title: Text('Feedback'),
            onTap: () {
               Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReviewForm()));
            },
          ),
        ],
      ),
    );
  }
}
