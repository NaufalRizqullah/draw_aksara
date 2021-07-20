import 'package:draw_aksara/model/assets_image_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class AssetsImageBaseApi {


  static Future<List<String>?> getAssetsImageBaseLocally(
      BuildContext context) async {
    final data = await rootBundle.loadString('assets/base/json/list.json');
    final jsonBody = json.decode(data);
    final list = AssetsImageBase.fromJson(jsonBody);
    var result = list.listBase;
    return result;
  }
}
