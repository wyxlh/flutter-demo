
import 'package:client/core/model/home/recharge_model.dart';
import 'package:client/core/model/home/recharge_pay_type_model.dart';
import 'package:client/core/service/basic/http_request.dart';

class WFRechargeRequest {

  // 获取充值配置
  static Future<List<WFChargeConfigModel>> getRechargeConfigData() async {
    // 构建 url
    final url = 'yzc-app-api/yzc-app/v1/member/recharge/config';
    final result = await HttpRequest.request(url,method: 'post',params: {});

    // 拿到的数据
    final resultList = result['data'];

    List<WFChargeConfigModel> models = List<WFChargeConfigModel>();
    for (var json in resultList) {
      models.add(WFChargeConfigModel.fromJson(json));
    }

    return models;
  }

  // 获取支付类型
  static Future<List<WFPayTypeModel>> getPayTypeData() async {
    // 构建 url
    final url = 'yzc-app-api/yzc-app/v1/pay/payMethod';
    // 发送请求
    final result = await HttpRequest.request(url,method: 'post',params: {});
    // 拿到数据
    final resultList = result['data'];

    // 转模型
    List<WFPayTypeModel> payList = [];
    for (var json in resultList) {
      payList.add(WFPayTypeModel.fromJson(json));
    }

    return payList;
  }

}