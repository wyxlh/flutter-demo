
import 'package:flutter/material.dart';
import 'package:client/core/model/home/recharge_model.dart';
import 'package:client/core/model/home/recharge_pay_type_model.dart';
import 'package:client/core/service/home/recharge_request.dart';
import 'package:client/ui/shared/help.dart';
import 'package:client/ui/shared/size_fit.dart';
import '../../../core/extension/int_extension.dart';

class WFRechargeContent extends StatefulWidget {
  @override
  _WFRechargeContentState createState() => _WFRechargeContentState();
}

class _WFRechargeContentState extends State<WFRechargeContent> {
   // 充值配置
   var _rechargeList = [];
   //支付方式
   var _payTypeList = [];
   // banner 图
   String _path = '';


   @override
  void initState() {
     super.initState();
    // TODO: implement initState
     // 获取充值配置
     WFRechargeRequest.getRechargeConfigData().then((res){
       setState(() {
         _rechargeList = res;
       });
     });

     // 获取支付方式
     WFRechargeRequest.getPayTypeData().then((res){
       setState(() {
         _payTypeList = res;
         if (_payTypeList.length != 0) {
           WFPayTypeModel model = _payTypeList[0];
           model.isSelect = 1;
           _path = model.banner;
         }
       });
     });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildBanner(),
            Row(children: <Widget>[_buildTitle('我的充值')]),
            _buildRechargeMoney(),
            Row(children: <Widget>[_buildTitle('选择支付方式')]),
            _buildPayType(),
            _buildRechargeButton()
          ],
        ),
      ),
    );
  }

  // 1 banner
  Widget _buildBanner() {
    return Image.network('$_path',height: 101.px,);
  }

  // 2 充值
  Widget _buildRechargeMoney() {
    return GridView.builder(
        padding: EdgeInsets.only(left: 15.px,right: 15.px),
        itemCount: _rechargeList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15.px,
          mainAxisSpacing: 15.px,
          childAspectRatio: 165/85,
        ),
        itemBuilder: (ctx,index) {
          WFChargeConfigModel model = _rechargeList[index];
          return GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: model.defaultFlag ? Color(0xFFFAEAE3) : Colors.white,
                borderRadius: BorderRadius.circular(10.px),
                border:Border.all(
                    color: model.defaultFlag ? WFHelp.mainColor : Colors.white,
                    width: 0.5
                ),
              ),
              child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('${model.money}元'),
                      if (model.giveMoney != 0.0)
                      Text('${model.giveMoney}元')
                    ],
                  )
              ),
            ),
            onTap: () {
              setState(() {
                for (WFChargeConfigModel itemModel in _rechargeList) {
                  itemModel.defaultFlag = false;
                }
                model.defaultFlag = true;
              });
            },
          );
        });
  }

  // 3 支付方式
  Widget _buildPayType() {
    return Container(
      color: Colors.white,
      child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: _payTypeList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (ctx,index) {
            WFPayTypeModel model = _payTypeList[index];
            String selectName = model.isSelect == 1 ? 'select_item.png' : 'un_select_item.png';
            return GestureDetector(
              child: ListTile(
                title: Text('${model.name}'),
                leading: Image.network(model.icon,width: 36.px,height: 36.px,),
                trailing: Image.asset('assets/images/user/$selectName',width: 22.px,height: 22.px,),
              ),
              onTap: () {
                setState(() {
                  for (WFPayTypeModel itemModel in _payTypeList) {
                    itemModel.isSelect = 0;
                  }
                  model.isSelect = 1;
                });
              },
            );
          },
          separatorBuilder: (ctx, index) {
            return Padding(
              padding:  EdgeInsets.only(left: 30.px),
              child: Divider(height: 1,),
            );
          }),
    );
  }

  // 4 充值按钮
  Widget _buildRechargeButton() {
    return Container(
      width: WYSizeFit.screenWidth,
      height: 70.px,
      color: WFHelp.mainBgColor,
      child: Padding(
        padding: EdgeInsets.only(left: 15.px,right: 15.px,top: 30.px),
        child: FlatButton(
          color: WFHelp.mainColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.px),
          ),
          child: Text('充值',style: TextStyle(color: Colors.white,fontSize: 16.px,fontWeight: FontWeight.bold),),
          onPressed: () {
            print('111');
          },
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 15.px,top: 14.px,bottom: 12.px),
      child: Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16.px,color: Color(0xFF333333)),),
    );
  }
}
