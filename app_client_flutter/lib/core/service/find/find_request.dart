
import 'package:client/core/model/find/find_model.dart';
import 'package:client/core/service/basic/http_request.dart';

class WFFindRequest {

    static Future<List<WFFindModel>> getFindData() async {
        // 1 构建 url
        final url = 'yzc-app-api/yzc-app/v1/system/activity';
        // 2 发送请求
        Map<String, dynamic> params = {'pageNo':'1','pageSize':'10'};
        final result = await HttpRequest.request(url,params: params);
        // 3 数据转模型
        final resultList = result['data']['list'];
        List<WFFindModel> findList =  List<WFFindModel>();
        for (var json in resultList) {
            findList.add(WFFindModel.fromJson(json));
        }
        return findList;
  }
}