import 'package:flutter/material.dart';
import 'package:todo_app/flavors/flavors_config.dart';
import 'package:todo_app/main.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorsConfig.initialize(Flavors.prod);
  defultMain();
}