import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sozzle/app.dart';
import 'package:sozzle/bootstrap.dart';
import 'package:sozzle/core/environment.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  Environment.instance.setEnvironment(EnvironmentType.DEVELOPMENT);
  bootstrap(() => const App());
}
