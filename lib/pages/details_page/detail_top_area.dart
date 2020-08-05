import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../provider/details_info.dart';

class DetailTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailsInfo>(
        builder: (context, DetailsInfo detail_info, child) {
      var info = Provider.of<DetailsInfo>(context, listen: false)
          .goodsInfo
          .data
          .goodInfo;
      return Container(
        child: Column(
          children: <Widget>[
            _goodsImage(info.image1),
            _goodsName(info.goodsName),
            _goodsNum(info.goodsSerialNumber),
            _goodsPrice(info.presentPrice, info.oriPrice),
          ],
        ),
      );
    });
  }
}

// 商品图片
Widget _goodsImage(url) {
  return Container(
    child: Image.network(url),
    width: ScreenUtil().setWidth(740),
  );
}

//商品名称
Widget _goodsName(name) {
  return Container(
    padding: EdgeInsets.only(left: 15.0),
    width: ScreenUtil().setWidth(740),
    child: Text(
      name,
      style: TextStyle(fontSize: ScreenUtil().setSp(30)),
    ),
  );
}

Widget _goodsNum(num) {
  return Container(
    width: ScreenUtil().setWidth(740),
    padding: EdgeInsets.only(left: 15.0),
    margin: EdgeInsets.only(top: 8.0),
    child: Text(
      '编号:${num}',
      style: TextStyle(color: Colors.black26),
    ),
  );
}

Widget _goodsPrice(presentPrice, oldPrice) {
  return Container(
    width: ScreenUtil().setWidth(730),
    margin: EdgeInsets.only(top: 8.0),
    padding: EdgeInsets.only(left: 15.0, bottom: 8.0),
    child: Row(
      children: <Widget>[
        Text(
          '￥${presentPrice}',
          style: TextStyle(
              fontSize: ScreenUtil().setSp(50), color: Colors.deepOrangeAccent),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: Text('市场价'),
        ),
        Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: Text(
              '￥${oldPrice}',
              style: TextStyle(decoration: TextDecoration.lineThrough),
            ))
      ],
    ),
  );
}
