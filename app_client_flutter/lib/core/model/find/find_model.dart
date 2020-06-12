class WFFindModel {
  int id;
  String name;
  String picUrl;
  String jumpUrl;
  int jumpType;
  String param;

  WFFindModel(
      {this.id,
        this.name,
        this.picUrl,
        this.jumpUrl,
        this.jumpType,
        this.param});

  WFFindModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    picUrl = json['picUrl'];
    jumpUrl = json['jumpUrl'];
    jumpType = json['jumpType'];
    param = json['param'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['picUrl'] = this.picUrl;
    data['jumpUrl'] = this.jumpUrl;
    data['jumpType'] = this.jumpType;
    data['param'] = this.param;
    return data;
  }
}
