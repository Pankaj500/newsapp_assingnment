import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_managemant/controllers/headline_controller.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});
  final TextEditingController name = TextEditingController();
  final TextEditingController address = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final headline = ref.watch(headlineprovider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          title: const Text(
            'News App',
            style: TextStyle(),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: headline.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: width * 0.03,
                    right: width * 0.03,
                    top: height * 0.01,
                  ),
                  child: Container(
                    width: width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: height * 0.3,
                          width: width,
                          child: headline[index].urlToImage == null
                              ? const Center(
                                  child: Text('Error loading the Image'))
                              : Image.network(
                                  '${headline[index].urlToImage}',
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Text(
                          'Headline',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(headline[index].title.toString()),
                        Text(
                          'Source',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(headline[index].source!.name.toString()),
                        Text(
                          'Published at',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(headline[index].publishedAt.toString()),
                      ],
                    ),
                  ),
                );
              }),
        ));
  }
}
