class WFChargeConfigModel {
  int id;
  int giveAnnualCardMoney;
  dynamic money;
  dynamic giveMoney;
  int givePoint;
  String showText;
  bool deleteFlag;
  bool defaultFlag;

  WFChargeConfigModel(
      {this.id,
        this.money,
        this.giveMoney,
        this.givePoint,
        this.showText,
        this.deleteFlag,
        this.giveAnnualCardMoney,
        this.defaultFlag});

  WFChargeConfigModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    giveAnnualCardMoney = json['giveAnnualCardMoney'];
    money = json['money'];
    giveMoney = json['giveMoney'];
    givePoint = json['givePoint'];
    showText = json['showText'];
    deleteFlag = json['deleteFlag'];
    defaultFlag = json['defaultFlag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['money'] = this.money;
    data['giveMoney'] = this.giveMoney;
    data['givePoint'] = this.givePoint;
    data['showText'] = this.showText;
    data['deleteFlag'] = this.deleteFlag;
    data['giveAnnualCardMoney'] = this.giveAnnualCardMoney;
    data['defaultFlag'] = this.defaultFlag;
    return data;
  }
}

