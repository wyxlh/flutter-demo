import 'package:client/core/model/home/charge_model.dart';
import 'package:client/core/service/basic/http_request.dart';

class WFChargeRequest {
  // 获取片区充电信息
  static Future<WFChargeModel> getChargeData(Map<String,dynamic> params) async {
    final url = 'yzc-app-api/yzc-app/v1/charge/get/by/groupId';
    final result = await HttpRequest.request(url,params: params);
    WFChargeModel chargeModel = WFChargeModel.fromJson(result['data']);
    return chargeModel;
  }
}