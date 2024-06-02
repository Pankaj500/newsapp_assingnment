import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:task_managemant/controllers/headline_controller.dart';
import 'package:task_managemant/models/categories_model.dart';
import 'package:task_managemant/utils/apis.dart';

class CategoriesRepo {
  List<Sources> data = [];
  Future<void> getcategorydata(WidgetRef ref) async {
    Response response = await http.get(Uri.parse('${CategoryApi().catapi}'));
    var responsedata = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (Map<String, dynamic> i in responsedata['sources']) {
        data.add(Sources.fromJson(i));
      }
      ref.read(categorydataprovider.notifier).state = data;
    } else {
      print('some error occured');
    }
  }
}
