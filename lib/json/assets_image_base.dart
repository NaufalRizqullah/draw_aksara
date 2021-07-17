class AssetsImageBase {
  late List<String> listBase;

  AssetsImageBase(this.listBase);

  AssetsImageBase.fromJson(Map<String, dynamic> json) {
    listBase = json['listBase'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['listBase'] = this.listBase;
    return data;
  }
}
