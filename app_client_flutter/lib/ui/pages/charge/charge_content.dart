import 'package:flutter/material.dart';
import 'package:client/core/model/home/charge_model.dart';
import 'package:client/core/service/home/charge_request.dart';
import 'package:client/ui/pages/search/search.dart';
import 'package:client/ui/shared/help.dart';
import 'package:client/ui/shared/size_fit.dart';
import '../../../core/extension/int_extension.dart';
import '../../../core/extension/double_extension.dart';

class WFChargeContent extends StatefulWidget {
  @override
  _WFChargeContentState createState() => _WFChargeContentState();
}

class _WFChargeContentState extends State<WFChargeContent> {

  int _count = 4;
  // 总的数据源
  WFChargeModel _chargeModel;
  // 插座数据
  List<SocketVo> _socketVoList;

  @override
  void initState() {
    // TODO: implement initState 3757 36
    super.initState();
    WFChargeRequest.getChargeData({'groupId':'36'}).then((res){
      setState(() {
        _chargeModel = res;
        // 默认桩号选中第一个
        if (_chargeModel.chargingListVo.length != 0) {
          ChargingListVo _listVoModel = _chargeModel.chargingListVo[0];
          _listVoModel.isSelect = 1;
          _socketVoList = _listVoModel.socketVo;
        }

      });
    });
  }

  @override
  Widget build(BuildContext context) {

    if (_chargeModel == null) return Center(child: CircularProgressIndicator());

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: WYSizeFit.screenHeight-100-55.px,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                _buildAddress(), // 地址
                SizedBox(height: 10.px),
                _buildChargePost(), // 充电桩
                SizedBox(height: 10.px),
                _buildSocket(), // 插座
                SizedBox(height: 10.px),
                _buildBillingMethod(), // 计费方式
                SizedBox(height: 10.px),
              ],
            ),
          ),
          Container(
            height: 55.px,
            child: _buildBottomStartCharge(),
          )
        ],
      ),
    );
  }

  // 1 地址
  Widget _buildAddress() {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            _buildAddressTitle(),
            _buildDetailAddress()
          ],
        ),
      ),
      onTap: () {
        Navigator.of(context).pushNamed(WFSearchScreen.routeName);
      },
    );
  }

  // 1.1 地址 title
  Widget _buildAddressTitle() {
    return Padding(
      padding:  EdgeInsets.all(15.px),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('当前片区'),
          Container(
            child: Row(
              children: <Widget>[
                Text('更换片区',style: TextStyle(color: WFHelp.mainColor,fontSize: 13.px),),
                Icon(Icons.arrow_forward_ios,color: Color(0xFF9C9C9C),size: 15,),
              ],
            ),
          )
        ],
      ),
    );
  }

  // 1.2 具体地址
  Widget _buildDetailAddress() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: 15.px,),
        Image.asset('assets/images/charge/new_charge_location.png',width: 15.px,height: 15.px,),
        SizedBox(width: 8.px),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: 15.px),
            child: Text( _chargeModel.name,style: TextStyle(color: WFHelp.mainTextColor,
                fontSize: 14.px,
                fontWeight: FontWeight.bold,
              ),maxLines: 2,),
          ),
        ),
      ],
    );
  }


  // 2 选择充电桩桩号
  Widget _buildChargePost() {
    // 一共多少个桩
    int _chargingListCount = _chargeModel.chargingListVo.length;

    return Container(
      color: Colors.white,
      height: 106.px,
      child: Column(
        children: <Widget>[
          _buildSectionTitle('请选择充电桩号'),
          GridView.builder(
            padding: EdgeInsets.only(left: 15.px,right: 15.px),
            itemCount: _chargingListCount,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: (WYSizeFit.screenWidth-_count*8.px)/_chargingListCount/46.px,
              mainAxisSpacing: 8.px,
              crossAxisSpacing: 8.px,
              crossAxisCount:_chargingListCount > 5 ? 5 : _chargingListCount,
            ),
            itemBuilder: (ctx,index) {
              // 拿到单个 model
              ChargingListVo _listModel = _chargeModel.chargingListVo[index];
              return GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _listModel.isSelect == 0 ? Colors.white : WFHelp.mainColor,
                    borderRadius: BorderRadius.circular(10.px),
                    border: Border.all(color: WFHelp.dashLineColor, width: 0.5),
                  ),
                  child: Text( '${_listModel.letter}桩',
                      style: TextStyle(
                        color: _listModel.isSelect == 0  ? WFHelp.mainGreyTextColor : Colors.white,
                        fontSize: 15.px,
                        fontWeight: FontWeight.bold),
                    ),
                  ),
                onTap: () {
                  // 选择桩
                  // 将所有的都设置为不选中
                  for (var itemModel in _chargeModel.chargingListVo) {
                    itemModel.isSelect = 0;
                  }
                  setState(() {
                    // 设置当前选中
                    _listModel.isSelect = 1;
                  });
                },
              );
              })
        ],
      ),
    );
  }

  // 3 插座
  Widget _buildSocket() {
    // 一行能显示的个数
    int _rouCount = _socketVoList.length > 4 ? 4 : _socketVoList.length;

    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _buildSectionTitle('请选择充电插座'),
          GridView.builder(
            padding: EdgeInsets.only(left: 15.px,right: 15.px,bottom: 15.px),
            itemCount: _socketVoList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _rouCount,
              crossAxisSpacing: 8.px,
              mainAxisSpacing: 8.px,
              childAspectRatio: (WYSizeFit.screenWidth-_count*8.px)/_rouCount/46.px,
            ),
            itemBuilder: (ctx,index) {
              // 获取单个插座数据
              SocketVo _itemSocket = _socketVoList[index];
              // 选中和不选中的字体颜色
              Color textColor = _itemSocket.isSelect == 1 ? Colors.white : WFHelp.mainGreyTextColor;

              return GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _itemSocket.isSelect == 1 ? WFHelp.mainColor : Colors.white,
                    borderRadius: BorderRadius.circular(10.px),
                    border: Border.all(color: WFHelp.dashLineColor, width: 0.5),
                  ),
                  child: Text('${_itemSocket.code}',style: TextStyle(color: textColor,fontSize: 15.px,fontWeight: FontWeight.bold),),
                ),

                onTap: () {
                  // 选择插座
                  for (var itemModel in _socketVoList) {
                    itemModel.isSelect = 0;
                  }
                  setState(() {
                    _itemSocket.isSelect = 1;
                  });

                },
              );
            }
          )
        ],
      ),
    );
  }

  // 4 选择计费方式
  Widget _buildBillingMethod() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          _buildSectionTitle('请选择计费方式'),
          GridView.builder(
            padding: EdgeInsets.only(left: 15.px,right: 15.px,bottom: 15.px),
            itemCount: _chargeModel.basePriceList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.px,
              mainAxisSpacing: 8.px,
              childAspectRatio: (WYSizeFit.screenWidth-_count*8.px)/3/46.px,
            ),
            itemBuilder: (ctx,index) {
              // 获取单个收费 model
              BasePriceList _priceModel = _chargeModel.basePriceList[index];
              // 拿到片区的计费 name
              String price = _priceModel.groupBillingPlanId == null ? getMoneyOrTime(_priceModel.time, _priceModel.state) : _priceModel.newTime;
              // 选中和不选中的字体颜色
              Color textColor = _priceModel.isSelect == 1 ? Colors.white : WFHelp.mainGreyTextColor;
              return GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _priceModel.isSelect == 0 ? Colors.white : WFHelp.mainColor,
                    borderRadius: BorderRadius.circular(10.px),
                    border: Border.all(color: WFHelp.dashLineColor, width: 0.5),
                  ),
                  child: Text('$price',style: TextStyle(color: textColor,fontSize: 15.px,fontWeight: FontWeight.bold),),
                ),
                onTap: () {
                  // 选择计费方式
                  for (var itemModel in _chargeModel.basePriceList) {
                    itemModel.isSelect = 0;
                  }
                  setState(() {
                    _priceModel.isSelect = 1;
                  });
                },
              );
            }
          )
        ],
      ),
    );
  }


  // 底部开始充电
  Widget _buildBottomStartCharge() {
    return Container(
      height: 55.px,
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding:  EdgeInsets.fromLTRB(15.px, 7.5.px, 15.px, 7.5.px),
        child: FlatButton(
          color: WFHelp.mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.px),
          ),
          child: Text('开始充电',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16.px),),
          onPressed: () {
            print('开始充电');
          },
        ),
      ),
    );
  }

  // 每个区域的 title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.all(15.px),
      child: Row(
        children: <Widget>[
          Text(title,style: TextStyle(color: WFHelp.mainTextColor,fontWeight: FontWeight.bold,fontSize: 16.px),),
        ],
      ),
    );
  }


  // 获取计费方式
  String getMoneyOrTime(int time,int state) {
    if (state == 1) return _chargeModel.fullStopName;

    if (time % 60 == 0) {
      String hour = (time / 60).toStringAsFixed(0);
      return ('$hour小时');
    } else if (time < 60) {
      return ('$time分钟');
    }
    // 保留一位小数
    String hour = (time / 60).toStringAsFixed(1);
    return ('$hour小时');
  }

}
