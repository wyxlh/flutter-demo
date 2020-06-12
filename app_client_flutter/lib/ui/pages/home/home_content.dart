import 'package:client/configure.dart';
import 'package:client/widget/webview/webview_page.dart';
import 'package:flutter/material.dart';
import 'package:marquee_flutter/marquee_flutter.dart';
import 'package:client/core/model/home/home_model.dart';
import 'package:client/core/service/home/home_request.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:client/ui/pages/charge/charge.dart';
import 'package:client/ui/pages/recharge/recharge.dart';
import 'package:client/ui/shared/help.dart';
import 'package:client/ui/shared/size_fit.dart';
import '../../../core/extension/int_extension.dart';
import '../../../core/extension/double_extension.dart';

// ignore: must_be_immutable
class WFHomeContent extends StatelessWidget{
  WFHomeModel _mainModel;
  @override
  Widget build(BuildContext context) {
    print('home build方法');
    return FutureBuilder<WFHomeModel>(
      future: WFHomeRequest.getHomeData(),
        builder: (ctx,snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          if (snapshot.error != null) return Center(child: Text("请求失败"),);

          _mainModel = snapshot.data;
          return Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _buildBannerWidget(),
                  _buildVajraThroneWidget(context),
                  _buildInformationWidget(context),
                  _mainModel.isNew ? _buildNewUserChargeWidget() : _buildOldUserChargeWidget(context),
                ],
              ),
            ),
          );
        }
    );
  }

  Widget _buildBannerWidget() {
    return Padding(
      padding: EdgeInsets.only(left: 12.px,right: 12.px,top: 12.px),
      child: Container(
        height: 160.px,
        child: Swiper(
          itemBuilder: (ctx, index) {
            return Image.network(_mainModel.rotationChartConfigList[index].picUrl,fit: BoxFit.fill,);
          },
          itemCount: _mainModel.rotationChartConfigList.length,
          autoplay: true,
          pagination: SwiperPagination(
              builder: DotSwiperPaginationBuilder(
                  activeColor: Color.fromRGBO(255, 255, 255, 0.8),
                  color: Color.fromRGBO(255, 255, 255, 0.3),
                  size: 10.0,
                  activeSize: 10.0)
          ),
          onTap: (index){
            print(index);
          },
        ),
      ),
    );
  }

  Widget _buildVajraThroneWidget(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: _mainModel.iconConfigList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 0.rpx,
          crossAxisSpacing: 0.rpx,
          // 宽高比
        ),
        itemBuilder: (ctx,index){
          return _buildVajraItemWidget(context, _mainModel.iconConfigList[index]);
        });
  }

  Widget _buildVajraItemWidget(BuildContext context, IconConfigList param) {
    return GestureDetector(child: Container(
      height: 114.px,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(param.picUrl,width: 45.px,height: 45.px,),
            SizedBox(height: 5.px,),
            Text(param.title),
          ],
        ),
      ),
    ), onTap: () {
      if (param.jumpType == 2) { //跳转H5
        Navigator.pushNamed(context, YZCWebviewPage.routeName, arguments: {'url': YZCConfigure.mkH5URLEx(param.jump),});
      } else { //跳转支付

      }
    },);
  }

  Widget _buildInformationWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.px,right: 12.px),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(17.px),
        ),
        height: 34.px,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MarqueeWidget(
              text: _mainModel.noticeConfigList[0].content,
              textStyle: TextStyle(fontSize: 12.0),
              scrollAxis: Axis.horizontal,
              ratioOfBlankToScreen: 0,
          ),
        ),
      ),
    );
  }

  Widget _buildNewUserChargeWidget() {
    return Column(
      children: <Widget>[
        GestureDetector(
          child: Image.asset('assets/images/new_scan_btn.png',width: WYSizeFit.screenWidth - 80.px,),
          onTap: () {
            print('扫描充电');
          },
        ),
        GestureDetector(
          child: Container(
            height: 40.px,
            child: Text('手动选择充电',style: TextStyle(fontSize: 14.px,color: Color(0xFF666666)))
          ),
          onTap: () {
            print('手动选择充电');
          },
        ),
      ],
    );
  }

  Widget _buildOldUserChargeWidget(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 220.px,
        child: Stack(
          children: <Widget>[
            Image.asset('assets/images/new_old_charge_bg.png'),
            Positioned(
              child: Column(
                children: <Widget>[
                  Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.asset('assets/images/new_address_logo.png',width: 13.px,height: 15.px,),
                      SizedBox(width: 7.px,),
                      Expanded(child: Text('上次充电小区：长沙市芙蓉宝庆金沙市芙蓉宝庆金沙市芙蓉宝庆金都小区',
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14.px,color: Color(0xFF333333)),maxLines:2,))
                    ],
                  ),
                  SizedBox(height: 10.px,),
                  Row(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                        color: WFHelp.mainColor,
                        borderRadius: BorderRadius.circular(2.5.px),
                        ),
                        width: 5.px,height: 5.px,),
                      SizedBox(width: 7.px,),
                      Text('上次使用充电桩：充电桩A',style: TextStyle(fontSize: 12.px,color: Color(0xFF999999)),),
                    ],
                  )
                ],
              ),
              right: 40.px,
              top: 40.px,
              left: 40.px,

            ),
            Positioned(
              child: Image.asset('assets/images/new_old_charge.png',),
              left: 50.px,right: 50.px,bottom: 25.px,
            ),
            Positioned (
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/new_gray_scan@3x.png',width: 13.px,height: 13.px,),
                  SizedBox(width: 5.px,),
                  Text('扫码充电',style: TextStyle(fontSize: 14.px,color: Color(0xFF666666)),)
                ],
              ),
              left: 50.px,right: 50.px,bottom: 10.px,
            )

          ],
        ),
      ),
      onTap: () {
        // 充电
        Navigator.of(context).pushNamed(WFChargeScreen.routeName);
      },
    );
  }
}
