import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:min_chat/app/app.dart';
import 'package:min_chat/core/di/di.dart';
import 'package:min_chat/firebase_options.dart';

void main() async {
  await setup();
  runApp(const MinChat());
}

// ignore:  inference_failure_on_function_return_type, always_declare_return_types, type_annotate_public_apis
setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  initDependencies();
}
