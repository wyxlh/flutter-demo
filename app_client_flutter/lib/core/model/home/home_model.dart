class WFHomeModel {
  List<IconConfigList> iconConfigList;
  List<NoticeConfigList> noticeConfigList;
  List<RotationChartConfigList> rotationChartConfigList;
  LastChargingInfo lastChargingInfo;
  bool isNew;

  WFHomeModel(
      {this.iconConfigList,
        this.noticeConfigList,
        this.rotationChartConfigList,
        this.lastChargingInfo,
        this.isNew});

  WFHomeModel.fromJson(Map<String, dynamic> json) {
    if (json['iconConfigList'] != null) {
      iconConfigList = new List<IconConfigList>();
      json['iconConfigList'].forEach((v) {
        iconConfigList.add(new IconConfigList.fromJson(v));
      });
    }
    if (json['noticeConfigList'] != null) {
      noticeConfigList = new List<NoticeConfigList>();
      json['noticeConfigList'].forEach((v) {
        noticeConfigList.add(new NoticeConfigList.fromJson(v));
      });
    }
    if (json['rotationChartConfigList'] != null) {
      rotationChartConfigList = new List<RotationChartConfigList>();
      json['rotationChartConfigList'].forEach((v) {
        rotationChartConfigList.add(new RotationChartConfigList.fromJson(v));
      });
    }
    lastChargingInfo = json['lastChargingInfo'] != null
        ? new LastChargingInfo.fromJson(json['lastChargingInfo'])
        : null;
    isNew = json['isNew'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.iconConfigList != null) {
      data['iconConfigList'] =
          this.iconConfigList.map((v) => v.toJson()).toList();
    }
    if (this.noticeConfigList != null) {
      data['noticeConfigList'] =
          this.noticeConfigList.map((v) => v.toJson()).toList();
    }
    if (this.rotationChartConfigList != null) {
      data['rotationChartConfigList'] =
          this.rotationChartConfigList.map((v) => v.toJson()).toList();
    }
    if (this.lastChargingInfo != null) {
      data['lastChargingInfo'] = this.lastChargingInfo.toJson();
    }
    data['isNew'] = this.isNew;
    return data;
  }
}

class IconConfigList {
  String picUrl;
  String title;
  String jump;
  int jumpType;
  int orders;

  IconConfigList(
      {this.picUrl, this.title, this.jump, this.jumpType, this.orders});

  IconConfigList.fromJson(Map<String, dynamic> json) {
    picUrl = json['picUrl'];
    title = json['title'];
    jump = json['jump'];
    jumpType = json['jumpType'];
    orders = json['orders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['picUrl'] = this.picUrl;
    data['title'] = this.title;
    data['jump'] = this.jump;
    data['jumpType'] = this.jumpType;
    data['orders'] = this.orders;
    return data;
  }
}

class NoticeConfigList {
  String content;
  String jump;
  int jumpType;
  int orders;

  NoticeConfigList({this.content, this.jump, this.jumpType, this.orders});

  NoticeConfigList.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    jump = json['jump'];
    jumpType = json['jumpType'];
    orders = json['orders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['jump'] = this.jump;
    data['jumpType'] = this.jumpType;
    data['orders'] = this.orders;
    return data;
  }
}

class RotationChartConfigList {
  String picUrl;
  String jump;
  int jumpType;
  int orders;

  RotationChartConfigList({this.picUrl, this.jump, this.jumpType, this.orders});

  RotationChartConfigList.fromJson(Map<String, dynamic> json) {
    picUrl = json['picUrl'];
    jump = json['jump'];
    jumpType = json['jumpType'];
    orders = json['orders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['picUrl'] = this.picUrl;
    data['jump'] = this.jump;
    data['jumpType'] = this.jumpType;
    data['orders'] = this.orders;
    return data;
  }
}

class LastChargingInfo {
  int chargingId;
  int groupId;
  String chargingName;
  String groupName;
  int chargingSocketId;
  String chargingSocketCode;

  LastChargingInfo(
      {this.chargingId,
        this.groupId,
        this.chargingName,
        this.groupName,
        this.chargingSocketId,
        this.chargingSocketCode});

  LastChargingInfo.fromJson(Map<String, dynamic> json) {
    chargingId = json['chargingId'];
    groupId = json['groupId'];
    chargingName = json['chargingName'];
    groupName = json['groupName'];
    chargingSocketId = json['chargingSocketId'];
    chargingSocketCode = json['chargingSocketCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['chargingId'] = this.chargingId;
    data['groupId'] = this.groupId;
    data['chargingName'] = this.chargingName;
    data['groupName'] = this.groupName;
    data['chargingSocketId'] = this.chargingSocketId;
    data['chargingSocketCode'] = this.chargingSocketCode;
    return data;
  }
}

