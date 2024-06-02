import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_managemant/models/categories_model.dart';
import 'package:task_managemant/models/headline_model.dart';

final headlineprovider = StateProvider<List<Articles>>((ref) => []);

final categorydataprovider = StateProvider<List<Sources>>((ref) => []);

final dataprovider = StateProvider<List<Articles>>((ref) => []);
