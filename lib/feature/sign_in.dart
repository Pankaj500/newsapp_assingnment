import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_managemant/controllers/headline_controller.dart';
import 'package:task_managemant/feature/homepage.dart';
import 'package:task_managemant/repositeries/headlines_api.dart';

class SignIn extends ConsumerWidget {
  SignIn({super.key});
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final HeadlinesApiRepo _headlinesApiRepo = HeadlinesApiRepo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text(
          'Sign In',
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: width * 0.03, right: width * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(
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
                  var see = ref.watch(headlineprovider);
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: email.text, password: password.text)
                      .then((value) async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomePage()));
                    await _headlinesApiRepo.getheadlines(ref);
                    print(see.length);
                  });
                },
                child: Text('Sign In')),
          ],
        ),
      ),
    );
  }
}
