import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_managemant/models/headline_model.dart';

final headlineprovider = StateProvider<List<Articles>>((ref) => []);
