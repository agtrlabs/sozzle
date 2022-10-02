import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MockServer {
  static const String path = 'assets/mock/board_game.json';
  Future<List<dynamic>> loadAsset() async {
    final dataString = await rootBundle.loadString(path);
    List<dynamic> dataJson;
    try {
      dataJson = jsonDecode(dataString) as List<dynamic>;
      debugPrint(dataJson.toString());
    } catch (e, st) {
      dataJson = [];
      debugPrint('Failed to convert JSON from mock server. $e, $st');
    }
    return dataJson;
  }
}
