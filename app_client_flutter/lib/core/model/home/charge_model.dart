// To parse this JSON data, do
//
//     final wfChargeModel = wfChargeModelFromJson(jsonString);

import 'dart:convert';

WFChargeModel wfChargeModelFromJson(String str) => WFChargeModel.fromJson(json.decode(str));

String wfChargeModelToJson(WFChargeModel data) => json.encode(data.toJson());

class WFChargeModel {
  WFChargeModel({
    this.name, // 片区名
    this.groupId, // 片区 Id
    this.powerType, // 0 统一收费 1 功率收费
    this.charge,
    this.chargingListVo, // 充电桩
    this.basePriceList, // 价格
    this.newGroupPreferential,
    this.charingElePriceVoList, // 片区充满自停价格描述
    this.practiceElePriceVoList,
    this.prompting, // 充满自停说明
    this.newPrivilegeActivityUrl, //新用户图片
    this.fullStopName,
  });

  String name;
  int groupId;
  dynamic powerType;
  dynamic charge;
  List<ChargingListVo> chargingListVo;
  List<BasePriceList> basePriceList;
  dynamic newGroupPreferential;
  dynamic charingElePriceVoList;
  dynamic practiceElePriceVoList;
  String prompting;
  dynamic newPrivilegeActivityUrl;
  String fullStopName;

  factory WFChargeModel.fromJson(Map<String, dynamic> json) => WFChargeModel(
    name: json["name"],
    groupId: json["groupId"],
    powerType: json["powerType"],
    charge: json["charge"],
    chargingListVo: List<ChargingListVo>.from(json["chargingListVo"].map((x) => ChargingListVo.fromJson(x))),
    basePriceList: List<BasePriceList>.from(json["basePriceList"].map((x) => BasePriceList.fromJson(x))),
    newGroupPreferential: json["newGroupPreferential"],
    charingElePriceVoList: json["charingElePriceVOList"],
    practiceElePriceVoList: json["practiceElePriceVOList"],
    prompting: json["prompting"],
    newPrivilegeActivityUrl: json["newPrivilegeActivityUrl"],
    fullStopName: json["fullStopName"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "groupId": groupId,
    "powerType": powerType,
    "charge": charge,
    "chargingListVo": List<dynamic>.from(chargingListVo.map((x) => x.toJson())),
    "basePriceList": List<dynamic>.from(basePriceList.map((x) => x.toJson())),
    "newGroupPreferential": newGroupPreferential,
    "charingElePriceVOList": charingElePriceVoList,
    "practiceElePriceVOList": practiceElePriceVoList,
    "prompting": prompting,
    "newPrivilegeActivityUrl": newPrivilegeActivityUrl,
    "fullStopName": fullStopName,
  };
}

class BasePriceList {
  BasePriceList({
    this.id,
    this.time,
    this.newTime,
    this.price,
    this.state,
    this.charge,
    this.isFull,
    this.startPrice,
    this.baseElseList,
    this.groupBillingPlanId,
    this.isSelect
  });

  dynamic id;
  int time;
  String newTime;
  dynamic price;
  dynamic state;
  int charge;
  int isFull;
  int isSelect;
  dynamic startPrice;
  dynamic baseElseList;
  String groupBillingPlanId; // 新片区计费 Id

  factory BasePriceList.fromJson(Map<String, dynamic> json) => BasePriceList(
    id: json["id"],
    time: json["time"],
    newTime: json["newTime"],
    price: json["price"],
    state: json["state"],
    charge: json["charge"],
    isFull: json["isFull"],
    isSelect: 0,
    startPrice: json["startPrice"],
    baseElseList: json["baseElseList"],
    groupBillingPlanId: json["groupBillingPlanId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "time": time,
    "newTime": newTime,
    "price": price,
    "state": state,
    "charge": charge,
    "isFull": isFull,
    "isSelect": isSelect,
    "startPrice": startPrice,
    "baseElseList": baseElseList,
    "groupBillingPlanId": groupBillingPlanId,
  };
}

class ChargingListVo {
  ChargingListVo({
    this.gateWayId,
    this.id,
    this.letter,
    this.socketVo,
    this.productType,
    this.isSelect
  });

  dynamic gateWayId;
  int id;
  String letter;
  List<SocketVo> socketVo;
  int productType;
  int isSelect;

  factory ChargingListVo.fromJson(Map<String, dynamic> json) => ChargingListVo(
    gateWayId: json["gateWayId"],
    id: json["id"],
    letter: json["letter"],
    isSelect: 0,
    socketVo: List<SocketVo>.from(json["socketVo"].map((x) => SocketVo.fromJson(x))),
    productType: json["productType"],
  );

  Map<String, dynamic> toJson() => {
    "gateWayId": gateWayId,
    "id": id,
    "letter": letter,
    "isSelect": isSelect,
    "socketVo": List<dynamic>.from(socketVo.map((x) => x.toJson())),
    "productType": productType,
  };
}

class SocketVo {
  SocketVo({
    this.id,
    this.code,
    this.status,
    this.isSelect
  });

  int id;
  String code;
  int status;
  int isSelect;

  factory SocketVo.fromJson(Map<String, dynamic> json) => SocketVo(
    id: json["id"],
    code: json["code"],
    status: json["status"],
    isSelect: 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "status": status,
    "isSelect": isSelect,
  };
}
