import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../provider/details_info.dart';
import '../../provider/cart.dart';
import '../../provider/current_index.dart';

class DetailBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var info = Provider.of<DetailsInfo>(context, listen: false)
        .goodsInfo
        .data
        .goodInfo;
    //goodsId, goodsName, count, price, images
    var goodsId = info.goodsId;
    var goodsName = info.goodsName;
    var count = 1;
    var price = info.presentPrice;
    var images = info.image1;
    bool isCheck = true;
    return Container(
      width: ScreenUtil().setWidth(750),
      color: Colors.white,
      height: ScreenUtil().setHeight(80),
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              InkWell(
                onTap: () {
                  Provider.of<CurrentIndexProvider>(context, listen: false)
                      .changeIndex(2);
                  Navigator.pop(context);
                },
                child: Container(
                  width: ScreenUtil().setWidth(110),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.shopping_cart,
                    size: 35,
                    color: Colors.red,
                  ),
                ),
              ),
              Consumer<CartProvider>(
                  builder: (context, CartProvider cart, child) {
                int goodsCount =
                    Provider.of<CartProvider>(context).allGoodsCount;
                return Positioned(
                    top: 0,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(6, 3, 6, 3),
                      decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.white),
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Text(
                        '${goodsCount}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(22)),
                      ),
                    ));
              })
            ],
          ),
          InkWell(
            onTap: () {
              Provider.of<CartProvider>(context, listen: false)
                  .save(goodsId, goodsName, count, price, images, isCheck);
            },
            child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(320),
              height: ScreenUtil().setHeight(80),
              color: Colors.green,
              child: Text(
                '加入购物车',
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(28)),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Provider.of<CartProvider>(context, listen: false).remove();
            },
            child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().setWidth(320),
              height: ScreenUtil().setHeight(80),
              color: Colors.red,
              child: Text(
                '马上购买',
                style: TextStyle(
                    color: Colors.white, fontSize: ScreenUtil().setSp(28)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
