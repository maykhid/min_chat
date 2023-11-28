import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:min_chat/core/di/di.config.dart';

final locator = GetIt.instance;

@InjectableInit()
Future<void> initDependencies() async => locator.init();
