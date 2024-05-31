import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:task_managemant/controllers/headline_controller.dart';
import 'package:task_managemant/models/headline_model.dart';
import 'package:task_managemant/utils/apis.dart';

class HeadlinesApiRepo {
  List<Articles> data = [];
  Future<void> getheadlines(WidgetRef ref) async {
    Response response = await http.get(Uri.parse('$headlineapi'));
    var responsedata = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (Map<String, dynamic> i in responsedata['articles']) {
        data.add(Articles.fromJson(i));
      }
      ref.read(headlineprovider.notifier).state = data;
    } else {
      print('some error occured');
    }
  }
}
