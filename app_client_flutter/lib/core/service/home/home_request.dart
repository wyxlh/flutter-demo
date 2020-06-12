import 'package:client/core/model/home/home_model.dart';
import 'package:client/core/service/basic/http_request.dart';

class WFHomeRequest  {
  // 获取首页数据
  static Future<WFHomeModel> getHomeData() async {
    final url = 'yzc-app-api/yzc-app/v1/system/home';
    final result = await HttpRequest.request(url);
    WFHomeModel model = WFHomeModel.fromJson(result['data']);
    return model;
  }


}