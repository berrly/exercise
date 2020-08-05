import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../provider/details_info.dart';

class DetailsWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailsInfo>(builder: (context, DetailsInfo data, child) {
      var isRight = Provider.of<DetailsInfo>(context, listen: false).isRight;
      var isLeft = Provider.of<DetailsInfo>(context, listen: false).isLeft;
      return Row(
        children: <Widget>[
          __myTabBarLeft(context, isLeft),
          _myTabBarRight(context, isRight)
        ],
      );
    });
  }
}

Widget __myTabBarLeft(context, isleft) {
  return InkWell(
    onTap: () {
      Provider.of<DetailsInfo>(context, listen: false)
          .changeLeftAndRight('left');
    },
    child: Container(
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(375),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  width: 1.0, color: isleft ? Colors.pink : Colors.black))),
      child: Text(
        '详情',
        style: TextStyle(
            fontSize: ScreenUtil().setSp(28),
            color: isleft ? Colors.pink : Colors.black),
      ),
    ),
  );
}

Widget _myTabBarRight(context, isright) {
  return InkWell(
    onTap: () {
      Provider.of<DetailsInfo>(context, listen: false)
          .changeLeftAndRight('right');
    },
    child: Container(
      padding: EdgeInsets.all(10.0),
      alignment: Alignment.center,
      width: ScreenUtil().setWidth(375),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
                  width: 1.0, color: isright ? Colors.pink : Colors.black))),
      child: Text(
        '详情',
        style: TextStyle(
            fontSize: ScreenUtil().setSp(28),
            color: isright ? Colors.pink : Colors.black),
      ),
    ),
  );
}
