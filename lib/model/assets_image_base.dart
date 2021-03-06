import 'package:draw_aksara/services/assetsImageBase_api.dart';
import 'package:flutter/material.dart';

class AssetsImageBase extends ChangeNotifier {
  List<String>? listBase;
  bool _isLoading = true;

  AssetsImageBase();

  AssetsImageBase.fromJson(Map<String, dynamic> json) {
    listBase = json['listBase'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listBase'] = this.listBase;
    return data;
  }

  void fetchData(BuildContext context) {
    AssetsImageBaseApi.getAssetsImageBaseLocally(context)
        .then((value) => setListBase(value));
  }

  // getter
  bool getIsLoading() => _isLoading;
  List<String>? getListBase() => listBase;

  // setter
  void setIsLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void setListBase(List<String>? listBaseImage) {
    listBase = listBaseImage;
    notifyListeners();
    setIsLoading();
  }
}
