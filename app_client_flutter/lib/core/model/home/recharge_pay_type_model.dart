class WFPayTypeModel {
  int id;
  String name;
  String category;
  int orders;
  String remark;
  bool deleteFlag;
  bool hasRechargeActivities;
  String banner;
  String icon;
  String skipUrl;
  String skipType;
  String bannerPrompt;
  int isSelect;

  WFPayTypeModel(
      {this.id,
        this.name,
        this.category,
        this.orders,
        this.remark,
        this.deleteFlag,
        this.hasRechargeActivities,
        this.banner,
        this.icon,
        this.skipUrl,
        this.skipType,
        this.bannerPrompt,
        this.isSelect});

  WFPayTypeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    category = json['category'];
    orders = json['orders'];
    remark = json['remark'];
    deleteFlag = json['deleteFlag'];
    hasRechargeActivities = json['hasRechargeActivities'];
    banner = json['banner'];
    icon = json['icon'];
    skipUrl = json['skipUrl'];
    skipType = json['skipType'];
    bannerPrompt = json['bannerPrompt'];
    isSelect = json['isSelect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['category'] = this.category;
    data['orders'] = this.orders;
    data['remark'] = this.remark;
    data['deleteFlag'] = this.deleteFlag;
    data['hasRechargeActivities'] = this.hasRechargeActivities;
    data['banner'] = this.banner;
    data['icon'] = this.icon;
    data['skipUrl'] = this.skipUrl;
    data['skipType'] = this.skipType;
    data['bannerPrompt'] = this.bannerPrompt;
    data['isSelect'] = this.isSelect;
    return data;
  }
}

