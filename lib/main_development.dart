import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sozzle/app.dart';
import 'package:sozzle/bootstrap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  bootstrap(() => const App());
}
