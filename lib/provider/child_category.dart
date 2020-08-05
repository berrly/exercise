import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; //控制右边顶部当前激活的id
  int length = 0;
  String categoryId = '4';
  String subId = ''; //小类ID

  int page = 1; //列表页数，当改变大类或者小类时进行改变
  String noMoreText = ''; //显示更多的标识
  // int get count => _count;
  ChildCategory({this.childCategoryList, this.categoryId, this.noMoreText});
  getChildCategory(List<BxMallSubDto> list, String id) {
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '';
    all.mallCategoryId = '00';
    all.comments = 'null';
    all.mallSubName = '全部';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    length = childCategoryList.length;
    childIndex = 0;
    categoryId = id;
    subId = '';
    page = 1;
    noMoreText = '';
    notifyListeners();
  }

  //改变右边顶部子类的索引
  changeChildIndex(int index, String id) {
    childIndex = index;
    subId = id;
    page = 1;
    noMoreText = '';
    notifyListeners();
  }

  addPage() {
    page++;
  }

  //改变noMoreText数据
  changeNoMore(String text) {
    noMoreText = text;
    notifyListeners();
  }
}
