import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class MockServer {
  static const String path = 'assets/mock/board_game.json';
  Future<Map<String, dynamic>> loadAsset() async {
    final dataString = await rootBundle.loadString(path);
    Map<String, dynamic> dataJson;
    try {
      dataJson = jsonDecode(dataString) as Map<String, dynamic>;
    } catch (e) {
      dataJson = {};
      debugPrint('Failed to convert JSON from mock server.');
    }
    return dataJson;
  }
}
