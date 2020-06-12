import 'package:client/core/service/basic/h5_urls.dart';
import 'package:client/widget/webview/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:client/ui/shared/help.dart';
import '../../../configure.dart';
import '../../../core/extension/int_extension.dart';
import '../../../core/extension/double_extension.dart';

class WFUserContent extends StatelessWidget {

  final List<List<Map<String, String>>> titles = [
    [{'title':'包月套餐'},
     {'title':'充电券'},
     {'title':'IC卡'}],
    [{'title':'帮助指南'},
     {'title':'问题反馈'},
     {'title':'故障报修'}]];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(

      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            _buildHeadImage(context),// 头像
            _buildBalance(), // 余额
//            _buildDashLine(),
//            _buildOrder(context), // 订单
            _buildDashLine(),
            _buildPackageOrCard(context),// IC卡
            _buildDashLine(),
            _buildOtherSetting(context), // 其他
          ],
        ),
      ),
    );
  }

  // 1.头像和名字
  Widget _buildHeadImage(BuildContext context) {
    return Container(
      height: 90.px,
      child: FlatButton(color: Colors.transparent, highlightColor: Colors.transparent, splashColor: Colors.transparent,child: Row(
          children: <Widget>[
            // 设置圆角
            Padding(
              padding: EdgeInsets.only(left: 22.px),
              child: ClipRRect(
                child: Image.asset('assets/images/user/new_default_photo.png',width: 60.px,height: 60.px,),
                borderRadius: BorderRadius.circular(30.px),
              ),
            ),
            SizedBox(width: 10.px,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('默认昵称',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: WFHelp.mainTextColor),),
                SizedBox(height: 8.px,),
                Text('123456789',style: TextStyle(fontSize: 12,color: Color(0xFF333333)),),
              ],
            )
          ],
      ), onPressed: () {
        Navigator.pushNamed(context, YZCWebviewPage.routeName, arguments: {'url': YZCConfigure.mkH5URL(H5Urls.userInfo),});
      },),
    );
  }

  // 2 余额
  Widget _buildBalance() {
    return Container(
      height: 135.px,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15.px,right: 15.px,bottom: 15.px),
            child: Image.asset('assets/images/user/new_balance_bg.png'),
          ),

          Padding(
            padding: EdgeInsets.only(left: 40.px),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('余额(元)',style: TextStyle(fontSize: 16.px,color: Colors.white),),
                SizedBox(height: 5.px,),
                Text('0.00',style: TextStyle(fontSize: 34.px,color: Colors.white,fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          Positioned(
            right: 35.px,
            top: 42.5.px,
            child: Container(
              height: 35.px,
              width: 85.px,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(17.5.px),
              ),
              
              alignment: Alignment.center,
              child: Text('充值',style: TextStyle(fontSize: 16.px,color: Color(0xFFFF8833)),),
            ),
          )
        ],
      ),

    );
  }

  // 3 订单
  Widget _buildOrder(BuildContext context) {
    return Container(
      height: 111.px,
      child: Column(
        children: <Widget>[
          _buildOrderHeader(context),// 头部
           Padding(
             padding: EdgeInsets.only(left: 25.px,right: 18.px),
             child: Container(color: WFHelp.dashLineColor,height: 0.5,),
           ),// 分割线
          _buildOrderType()
        ],
      ),
    );
  }

  // 3.1 我的订单头部
  Widget _buildOrderHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.px,top: 10.px,bottom: 10.px,right: 18.px),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('我的订单',style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16.px),),
          Row(
            children: <Widget>[
              Text('查看全部订单',style: TextStyle(fontSize: 12.px,color: Color(0xFF999999)),),
              SizedBox(width: 5.px,),
              Icon(Icons.arrow_forward_ios,color: Color(0xFF9C9C9C),size: 15,),
            ],
          ),
        ],
      ),
    );
  }

  // 3.2 订单 全部订单 等
  Widget _buildOrderType() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildOrderItem('all', '全部'),
          _buildOrderItem('waitPay', '待付款'),
          _buildOrderItem('evaluate', '待收货'),
          _buildOrderItem('waitRec', '待评价'),
        ],
      ),
    );
  }

  //3.2.1 每个订单的 Widget
  Widget _buildOrderItem(String title, String name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset('assets/images/user/new_order_$title.png',width: 22.px,height: 22.px,),
        SizedBox(height: 5.px,),
        Text(name),
      ],
    );
  }

  // 4 套餐,充点券,IC卡
  Widget _buildPackageOrCard(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (ctx,index) {
          return _buildRowItem(context,0,index,titles[0][index]['title'],'充电套餐');
        },
        itemCount: titles[0].length
    );
  }

  // 5 帮助指南 问题反馈, 故障报修
  Widget _buildOtherSetting(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (ctx,index) {
          return _buildRowItem(context,1,index,titles[1][index]['title'],'');
        },
        itemCount: titles[1].length
    );
  }

  // 4.1 5.1 单行 Widget Cell
  Widget _buildRowItem(BuildContext context,int type, int index,String title,String vipStr) {
    return Container(
      height: 50.px,
      child: FlatButton(color: Colors.transparent, highlightColor: Colors.transparent, splashColor: Colors.transparent,child: Padding(
        padding: EdgeInsets.only(right: 18.px,left: 25.px),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 49.px,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(title,style: Theme.of(context).textTheme.body1.copyWith(fontSize: 16.px),),
                  Row(
                    children: <Widget>[
                      if (index == 0 && vipStr.length != 0)
                      Text(vipStr,style: TextStyle(fontSize: 12.px,color: WFHelp.mainColor),),
                      SizedBox(width: 5.px,),
                      Icon(Icons.arrow_forward_ios,color: Color(0xFF9C9C9C),size: 15,),
                    ],
                  ),
                ],
              ),
            ),
            if (index != index-1)
            Container(color: WFHelp.dashLineColor,height: 0.5,),
          ],
        ),
      ), onPressed: () {
        if (type == 0) {
          switch (index) {
            case 0: //包月套餐
              Navigator.pushNamed(context, YZCWebviewPage.routeName, arguments: {'url': YZCConfigure.mkH5URL(H5Urls.monthlyPackage),});
              break;
            case 1: //充电券
              Navigator.pushNamed(context, YZCWebviewPage.routeName, arguments: {'url': YZCConfigure.mkH5URL(H5Urls.rechargeTickets),});
              break;
            case 2: //IC卡
              Navigator.pushNamed(context, YZCWebviewPage.routeName, arguments: {'url': YZCConfigure.mkH5URL(H5Urls.icCard),});
              break;
          }
        } else {
          switch (index) {
            case 0: //帮助指南
              Navigator.pushNamed(context, YZCWebviewPage.routeName, arguments: {'url': YZCConfigure.mkH5URL(H5Urls.help),});
              break;
            case 1: //问题反馈
              Navigator.pushNamed(context, YZCWebviewPage.routeName, arguments: {'url': YZCConfigure.mkH5URL(H5Urls.advice),});
              break;
            case 2: //故障报修
              Navigator.pushNamed(context, YZCWebviewPage.routeName, arguments: {'url': YZCConfigure.mkH5URL(H5Urls.repair),});
              break;
          }
        }
      },),
    );
  }

  // 6 分割线
  Widget _buildDashLine() {
    return Container(
      height: 10,
      color: WFHelp.mainBgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(color: WFHelp.dashLineColor,height: 0.5,),
          Container(color: WFHelp.dashLineColor,height: 0.5,),
        ],
      )
    );
  }
}
