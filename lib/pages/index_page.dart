import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'category_page.dart';
import 'cart_page.dart';
import 'member_page.dart';
import '../provider/current_index.dart';

class IndexPage extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), title: Text('首页')),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.search), title: Text('分类')),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.shopping_cart), title: Text('购物车')),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.profile_circled), title: Text('会员中心'))
  ];

  final List<Widget> tabBodies = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage()
  ];
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
    return Container(
      child: Consumer<CurrentIndexProvider>(
          builder: (context, CurrentIndexProvider value, child) {
        var currentIndex =
            Provider.of<CurrentIndexProvider>(context, listen: false)
                .currentIndex;
        return Scaffold(
          backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
          bottomNavigationBar: BottomNavigationBar(
            items: bottomTabs,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: (index) {
              Provider.of<CurrentIndexProvider>(context, listen: false)
                  .changeIndex(index);
            },
          ),
          body: IndexedStack(
            index: currentIndex,
            children: tabBodies,
          ),
        );
      }),
    );
  }
}

// class IndexPage extends StatefulWidget {
//   @override
//   _IndexPageState createState() => _IndexPageState();
// }

// class _IndexPageState extends State<IndexPage> {
//   final List<BottomNavigationBarItem> bottomTabs = [
//     BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), title: Text('首页')),
//     BottomNavigationBarItem(
//         icon: Icon(CupertinoIcons.search), title: Text('分类')),
//     BottomNavigationBarItem(
//         icon: Icon(CupertinoIcons.shopping_cart), title: Text('购物车')),
//     BottomNavigationBarItem(
//         icon: Icon(CupertinoIcons.profile_circled), title: Text('会员中心'))
//   ];

//   final List tabBodies = [HomePage(), CategoryPage(), CartPage(), MemberPage()];

//   int currentIndex = 0;
//   var indexStack;
//   var currentPage;

//   @override
//   void initState() {
//     currentPage = tabBodies[currentIndex];
//     super.initState();
//   }

//   //初始化栈数据
//   void _initStack() {
//     indexStack = new IndexedStack(
//       children: <Widget>[
//         HomePage(),
//         CategoryPage(),
//         CartPage(),
//         MemberPage(),
//       ],
//       index: currentIndex,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     ScreenUtil.init(context, width: 750, height: 1334, allowFontScaling: false);
//     _initStack();
//     return Scaffold(
//       backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
//       bottomNavigationBar: BottomNavigationBar(
//         items: bottomTabs,
//         type: BottomNavigationBarType.fixed,
//         currentIndex: currentIndex,
//         onTap: (index) {
//           setState(() {
//             currentIndex = index;
//             currentPage = tabBodies[currentIndex];
//           });
//         },
//       ),
//       body: indexStack,
//     );
//   }
// }
