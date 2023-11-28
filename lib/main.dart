import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:min_chat/app/app.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/core/di/di.dart';
import 'package:min_chat/firebase_options.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  await setup();
  runApp(const MinChat());
}

// ignore:  inference_failure_on_function_return_type, always_declare_return_types, type_annotate_public_apis
setup() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final dbPath = join(dir.path, '.db.hive');
  await Hive.initFlutter(dbPath);

  Hive.registerAdapter(AuthenticatedUserAdapter());

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initDependencies();
}
