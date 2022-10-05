import 'package:flutter/widgets.dart';
import 'package:sozzle/app.dart';
import 'package:sozzle/bootstrap.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  bootstrap(() => const App());
}
