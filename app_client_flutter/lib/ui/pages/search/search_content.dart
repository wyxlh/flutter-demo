import 'package:flutter/material.dart';
import 'package:client/ui/shared/help.dart';
import 'package:client/ui/shared/size_fit.dart';
import '../../../core/extension/int_extension.dart';

class WFSearchContent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildSearchNavView(context),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildLocationView(),
              _buildLatelyUsePileView(),
              _buildNearByAddressView(),
            ],
          ),
        )
      ],
    );
  }

  // 1, 头部搜索框
  Widget _buildSearchNavView(BuildContext context) {
    double _statusBarHeight= MediaQuery.of(context).padding.top;
    return Container(
      height: _statusBarHeight + kToolbarHeight,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(top: _statusBarHeight),
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 15.px,),
              GestureDetector(
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 22.px,
                  color: WFHelp.mainTextColor,
                ),
                onTap: () {
                    Navigator.of(context).pop();
                },
              ),
              SizedBox(width: 8.px,),
              _buildInputView(),
            ],
          ),
        ),
      ),
    );
  }

  // 1.1 搜索输入框
  Widget _buildInputView() {
    final usernameTextEditController = TextEditingController();
    return Container(
      height: 36,
      width: WYSizeFit.screenWidth - 60.px,
      decoration: BoxDecoration(
        color: Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.px),
            child: TextField(
              controller: usernameTextEditController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(left: -10,bottom: 12),
                icon: Padding(
                    padding: EdgeInsets.only(left: 10.px),
                    child: Image.asset('assets/images/charge/new_search_address.png',width: 15.px,height: 15.px,),
                ),
                hintText: "请输入充电桩地址",
                border: InputBorder.none,
                filled: true,
                fillColor: Color(0xFFEEEEEE),
              ),
              onChanged: (value) {
                print("onChange:$value");
              },
              onSubmitted: (value) {
                print("onSubmitted:$value");
              },
            ),
          ),
        ],
      )
    );
  }

  // 2, 重新定位
  Widget _buildLocationView() {
    return Container(
      color: Colors.white,
      height: 44.px,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(color: WFHelp.dashLineColor,height: 0.5,),
          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: 16.px),
              Text('定位地33333333址',style: TextStyle(color: WFHelp.mainTextColor),),
              Expanded(
                child: Text(''), // 中间用Expanded控件
              ),
              Row(
                children: <Widget>[
                  Image.asset('assets/images/charge/new_localogo.png',width: 15.px,height: 15.px,),
                  Text('重新定位',style: TextStyle(color: WFHelp.mainColor,fontSize: 14.px),)
                ],
              ),
              SizedBox(width: 15.px,),
            ],
          ),
          Container(color: WFHelp.dashLineColor,height: 0.5,),
        ],
      ),
    );
  }


  // 3, 最近使用的充电桩
  Widget _buildLatelyUsePileView() {
    return Column(
      children: <Widget>[
        _buildAddressHeader('最近使用充电桩地址','new_history_logo'),
        ListView.builder(
          itemCount: 3,
          shrinkWrap: true,
          itemBuilder: (ctx,index) {
            return Text('aa');
          },
        )
      ],
    );
  }


  // 4, 附近充电桩
  Widget _buildNearByAddressView() {
    return Column(
      children: <Widget>[
        _buildAddressHeader('附近充电桩地址','new_near_logo'),
      ],
    );
  }

  // 5 充电桩地址筛选头部
  Widget _buildAddressHeader(String title,String imgName) {
    return Row(
      children: <Widget>[
        Image.asset('assets/images/charge/$imgName.png',width: 15.px,height: 15.px,),
        Text('$title'),
      ],
    );
  }


}
