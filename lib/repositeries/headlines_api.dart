import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:task_managemant/controllers/headline_controller.dart';
import 'package:task_managemant/feature/categories.dart';
import 'package:task_managemant/feature/homepage.dart';
import 'package:task_managemant/models/headline_model.dart';

class HeadlinesApiRepo {
  List<Articles> data = [];
  Future<void> getheadlines(WidgetRef ref, BuildContext context) async {
    data.clear();
    ref.read(isloading.notifier).state = true;
    var country = ref.watch(countryprovider);
    Response response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=$country&apiKey=0018b57c6b8242c3b7449732ddf38528'));
    var responsedata = jsonDecode(response.body);
    print(response.body);
    if (response.statusCode == 200) {
      ref.read(isloading.notifier).state = false;
      for (Map<String, dynamic> i in responsedata['articles']) {
        data.add(Articles.fromJson(i));
      }
      ref.read(headlineprovider.notifier).state = data;
      ref.read(dataprovider.notifier).state = data;
    } else {
      ref.read(isloading.notifier).state = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('some error occur while fetching the data'),
        ),
      );
    }
  }
}
