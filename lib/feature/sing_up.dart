import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  SignUp({super.key});
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text(
          'Sing Up',
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextField(
            controller: email,
            decoration: const InputDecoration(
              label: Text('email'),
            ),
          ),
          TextField(
            controller: password,
            decoration: const InputDecoration(
              label: Text('password'),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: email.text, password: password.text)
                  .then((value) {
                print('user crated successfully');
              });
            },
            child: const Text('register'),
          ),
        ],
      ),
    );
  }
}
