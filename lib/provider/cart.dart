import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cartModel.dart';

class CartProvider with ChangeNotifier {
  String cartString = '[]';
  List<CartInfoModel> cartList = [];
  double allPrice = 0; //总价格
  int allGoodsCount = 0; //商品总数量
  bool isAllCheck = true; //是否全选
  save(goodsId, goodsName, count, price, images, isCheck) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    List<Map> tempList = (temp as List).cast();

    bool isHave = false;
    int ival = 0;
    allPrice = 0.0;
    allGoodsCount = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        tempList[ival]['count'] = item['count'] + 1;
        cartList[ival].count++;
        isHave = true;
      }
      if (item['isCheck']) {
        allPrice += item['price'] * item['count'];
        allGoodsCount += item['count'];
      }
      ival++;
    });
    if (!isHave) {
      Map<String, dynamic> newCoods = {
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'images': images,
        "isCheck": isCheck
      };
      allPrice += price * count;
      allGoodsCount += count;
      tempList.add(newCoods);
      cartList.add(new CartInfoModel.fromJson(newCoods));
    }

    //把tempList转为字符串存储在本地
    String tempString = json.encode(tempList).toString();
    print(tempString);
    print(cartList.toString());
    prefs.setString('cartInfo', tempString);
    notifyListeners();
  }

  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartInfo');
    cartList = [];
    print('清空---------------------------------------');
    notifyListeners();
  }

  getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tempString = prefs.getString('cartInfo');
    allPrice = 0.0;
    allGoodsCount = 0;
    cartList = [];
    if (tempString == null) {
      cartList = [];
    } else {
      List tempList = (json.decode(tempString.toString()) as List).cast();
      isAllCheck = true;
      tempList.forEach((item) {
        if (item['isCheck']) {
          allPrice += item['price'] * item['count'];
          allGoodsCount += item['count'];
        } else {
          isAllCheck = false;
        }
        cartList.add(new CartInfoModel.fromJson(item));
      });
    }
    print('清空---------------------------------------' + cartList.toString());
    notifyListeners();
  }

  deleteOneGoods(String goodsId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int nowindex = 0;
    int getIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        getIndex = nowindex;
      }
      nowindex++;
    });
    tempList.removeAt(getIndex);
    cartString = json.encode(tempList).toString();
    print('删除---------------------------------------');
    prefs.setString('cartInfo', cartString);

    await getCartInfo();
  }

  //修改选中状态
  changeCheckState(CartInfoModel cartItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int vint = 0;
    int chooseIndex = 0;
    tempList.forEach((item) {
      if (cartItem.goodsId == item['goodsId']) {
        chooseIndex = vint;
      }
      vint++;
    });
    tempList[chooseIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);

    await getCartInfo();
  }

  //全选按钮
  changeAllCheckBtnState(bool ischeck) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    List<Map> newList = []; //新建一个List，用于组成新的持久化数据。
    for (var item in tempList) {
      var newItem = item;
      item['isCheck'] = ischeck;
      newList.add(newItem);
    }
    cartString = json.encode(newList).toString(); //形成字符串
    prefs.setString('cartInfo', cartString); //进行持久化
    await getCartInfo();
  }

  //数量加减
  addOrReduceAction(CartInfoModel cartItem, String todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item) {
      if (item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    if (todo == 'add') {
      cartItem.count++;
    } else if (cartItem.count > 1) {
      cartItem.count--;
    }
    tempList[changeIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString); //
    await getCartInfo();
  }
}
