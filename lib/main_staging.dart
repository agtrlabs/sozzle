import 'package:flutter/widgets.dart';
import 'package:sozzle/app.dart';
import 'package:sozzle/bootstrap.dart';
import 'package:sozzle/core/environment.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Environment.instance.setEnvironment(EnvironmentType.STAGING);

  bootstrap(() => const App());
}
