import 'package:flutter/material.dart';
import '../service/service.method.dart';
import '../model/category.dart';
import '../model/categoryGoodsList.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../provider/child_category.dart';
import '../provider/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

//主体
class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            _LeftCategoryNav(),
            Column(
              children: <Widget>[RightCategoryNav(), CateGoodsList()],
            )
          ],
        ),
      ),
    );
  }
}

//左侧大类导航
class _LeftCategoryNav extends StatefulWidget {
  _LeftCategoryNav({Key key}) : super(key: key);

  @override
  __LeftCategoryNavState createState() => __LeftCategoryNavState();
}

class __LeftCategoryNavState extends State<_LeftCategoryNav> {
  List list = [];
  var listIndex = 0;
  @override
  void initState() {
    _getCategory();
    _getGoodsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(right: BorderSide(width: 1, color: Colors.black12)),
      ),
      child: ListView.builder(
          itemCount: list.length,
          // ignore: missing_return
          itemBuilder: (context, index) {
            return _leftInkWell(context, index);
          }),
    );
  }

  Widget _leftInkWell(context, index) {
    bool isClicked = false;
    isClicked = (index == listIndex) ? true : false;
    return InkWell(
      onTap: () {
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;
        Provider.of<ChildCategory>(context, listen: false)
            .getChildCategory(childList, categoryId);
        _getGoodsList(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10, top: 20),
        decoration: BoxDecoration(
            color:
                isClicked ? Color.fromRGBO(236, 236, 236, 1.0) : Colors.white,
            border:
                Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      ),
    );
  }

  void _getCategory() async {
    await request('getCategory').then((value) {
      var data = json.decode(value.toString());
      CategoryModel category = CategoryModel.fromJson(data);
      setState(() {
        list = category.data;
      });
      Provider.of<ChildCategory>(context, listen: false)
          .getChildCategory(list[0].bxMallSubDto, list[0].mallCategoryId);
      //list.data.forEach((item) => {print(item.mallCategoryName)});
    });
  }

  void _getGoodsList({String categoryId}) async {
    var data = {
      'categoryId': categoryId != null ? categoryId : '4',
      'categorySubId': "",
      'page': 1
    };
    await request('getMallGoods', formData: data).then((value) {
      var data = json.decode(value.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      Provider.of<CategoryGoodsListProvider>(context, listen: false)
          .getGoodsList(goodsList.data);
      // setState(() {
      //   list = goodsList.data;
      // });
      // // print(data);
      // print(
      //     "分类商品列表>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>${goodsList.data[0].goodsName}");
    });
  }
}

//小类右侧顶部导航
class RightCategoryNav extends StatefulWidget {
  RightCategoryNav({Key key}) : super(key: key);

  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  // List list = ['名酒', '宝丰', '北京二锅头', '舍得', '五粮液', '茅台', '散白'];
  @override
  Widget build(BuildContext context) {
    return Consumer<ChildCategory>(
      builder: (context, ChildCategory childCategory, child) {
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.length,
            itemBuilder: (context, index) {
              return _rightInkWell(
                  index, childCategory.childCategoryList[index]);
            },
          ),
        );
      },
    );
  }

  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isclicked = false;
    isclicked =
        Provider.of<ChildCategory>(context).childIndex == index ? true : false;
    return InkWell(
      onTap: () {
        Provider.of<ChildCategory>(context, listen: false)
            .changeChildIndex(index, item.mallSubId);
        _getGoodsList(item.mallSubId);
      },
      child: Container(
          child: Text(
            item.mallSubName,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(28),
                color: isclicked ? Colors.pink : Colors.black),
          ),
          padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0)),
    );
  }

  void _getGoodsList(String categorySubId) {
    var data = {
      'categoryId':
          Provider.of<ChildCategory>(context, listen: false).categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };
    request('getMallGoods', formData: data).then((value) {
      var data = json.decode(value.toString());

      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if (goodsList.data == null) {
        Provider.of<CategoryGoodsListProvider>(context, listen: false)
            .getGoodsList([]);
      } else {
        Provider.of<CategoryGoodsListProvider>(context, listen: false)
            .getGoodsList(goodsList.data);
      }
    });
  }
}

//右侧下面商品列表
class CateGoodsList extends StatefulWidget {
  @override
  _CateGoodsListState createState() => _CateGoodsListState();
}

class _CateGoodsListState extends State<CateGoodsList> {
  var scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<RefreshFooterState> _footerKey = GlobalKey<RefreshFooterState>();

    return Consumer<CategoryGoodsListProvider>(
      builder: (context, data, child) {
        try {
          if (Provider.of<ChildCategory>(context).page == 1) {
            // 列表位置，放到最上边
            scrollController.jumpTo(0.0);
          }
        } catch (e) {
          print('进入页面第一次初始化：$e');
        }
        if (data.goodsList.length > 0) {
          return Expanded(
            child: Container(
              width: ScreenUtil().setWidth(570),
              child: EasyRefresh(
                refreshFooter: ClassicsFooter(
                    key: _footerKey,
                    bgColor: Colors.white,
                    textColor: Colors.pink,
                    moreInfoColor: Colors.pink,
                    showMore: true,
                    noMoreText: Provider.of<ChildCategory>(context).noMoreText,
                    moreInfo: '加载中',
                    loadReadyText: '上拉加载'),
                child: ListView.builder(
                    controller: scrollController,
                    itemCount: data.goodsList.length,
                    itemBuilder: (context, index) {
                      return _ListItemWidget(data.goodsList, index);
                    }),
                loadMore: () async {
                  _loadMoreList();
                },
              ),
            ),
          );
        } else {
          return Text('暂时没有数据');
        }
      },
    );
  }

  Widget _goodsImage(List newList, int index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodsName(List newList, int index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _GoodsPrice(List newList, int index) {
    return Container(
      width: ScreenUtil().setWidth(370),
      margin: EdgeInsets.only(top: 20.0),
      child: Row(
        children: <Widget>[
          Text(
            '价格:￥${newList[index].presentPrice}',
            style:
                TextStyle(fontSize: ScreenUtil().setSp(28), color: Colors.pink),
          ),
          Text(
            '￥${newList[index].oriPrice}',
            style: TextStyle(
                color: Colors.black26, decoration: TextDecoration.lineThrough),
          )
        ],
      ),
    );
  }

  Widget _ListItemWidget(List newList, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(bottom: BorderSide(width: 1.0, color: Colors.black12))),
        child: Row(
          children: <Widget>[
            _goodsImage(newList, index),
            Column(
              children: <Widget>[
                _goodsName(newList, index),
                _GoodsPrice(newList, index)
              ],
            )
          ],
        ),
      ),
    );
  }

  void _loadMoreList() {
    Provider.of<ChildCategory>(context, listen: false).addPage();
    var data = {
      'categoryId':
          Provider.of<ChildCategory>(context, listen: false).categoryId,
      'categorySubId': Provider.of<ChildCategory>(context, listen: false).subId,
      'page': Provider.of<ChildCategory>(context, listen: false).page
    };
    request('getMallGoods', formData: data).then((value) {
      var data = json.decode(value.toString());
      print(value);
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if (goodsList.data == null) {
        //Provider.of<ChildCategory>(context).changeNoMore('没有更多了');
        Fluttertoast.showToast(
            msg: '已经到底了',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Provider.of<CategoryGoodsListProvider>(context, listen: false)
            .addGoodsList(goodsList.data);
      }
    });
  }
}
