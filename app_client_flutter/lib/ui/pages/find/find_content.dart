import 'package:flutter/material.dart';
import 'package:client/core/model/find/find_model.dart';
import 'package:client/core/service/find/find_request.dart';
import 'package:client/ui/pages/recharge/recharge.dart';
import 'package:client/ui/shared/size_fit.dart';
import '../../../core/extension/int_extension.dart';

class WFFindContent extends StatelessWidget {
   List<WFFindModel> _findList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<WFFindModel>>(
      future: WFFindRequest.getFindData(),
      builder: (ctx,snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        if (snapshot.error != null) return Center(child: Text("请求失败"),);

        _findList = snapshot.data;

        return ListView.builder(
            padding: EdgeInsets.only(top: 5.px),
            itemCount: _findList.length,
            itemBuilder: (ctx, index) {
              return _buildItemWidget(_findList[index], context);
            }
        );
      },
    );


  }

  Widget _buildItemWidget(WFFindModel model,BuildContext context) {
    return GestureDetector(
      child: Container(
          child: Column(
            children: <Widget>[
              Image.network(model.picUrl,height: 200.px,width: WYSizeFit.screenWidth-30.px,),
              SizedBox(height: 10.px,)
            ],
          )
      ),
      onTap: () {
        Navigator.of(context).pushNamed(WFRechargeScreen.routeName);
      },
    );
  }
}
