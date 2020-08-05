import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service.method.dart';
import 'dart:convert';

class DetailsInfo with ChangeNotifier {
  DetailsModel goodsInfo;
  bool isLeft = true;
  bool isRight = false;
  changeLeftAndRight(String changeState) {
    if (changeState == 'left') {
      isLeft = true;
      isRight = false;
    } else {
      isLeft = false;
      isRight = true;
    }
    notifyListeners();
  }

  getGoodsInfo(String id) async {
    var formData = {"goodId": id};
    await request('getGoodDetailById', formData: formData).then((value) {
      var responseData = json.decode(value.toString());
      // print(responseData);
      goodsInfo = DetailsModel.fromJson(responseData);
      notifyListeners();
    });
  }
}
