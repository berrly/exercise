import 'package:flutter/material.dart';
import 'package:flutter_shop/provider/counter.dart';
import 'package:provider/provider.dart';
import './provider/counter.dart';
import './provider/child_category.dart';
import './provider/category_goods_list.dart';
import './provider/details_info.dart';
import './pages/index_page.dart';
import 'package:fluro/fluro.dart';
import './routers/router.dart';
import './routers/application.dart';
import './provider/cart.dart';
import './provider/current_index.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<Counter>.value(
        value: Counter(),
      ),
      ChangeNotifierProvider<ChildCategory>.value(
        value: ChildCategory(),
      ),
      ChangeNotifierProvider<CategoryGoodsListProvider>.value(
        value: CategoryGoodsListProvider(),
      ),
      ChangeNotifierProvider<DetailsInfo>.value(
        value: DetailsInfo(),
      ),
      ChangeNotifierProvider<CartProvider>.value(
        value: CartProvider(),
      ),
      ChangeNotifierProvider<CurrentIndexProvider>.value(
        value: CurrentIndexProvider(),
      )
    ],
    child: MyApp(),
  ));
}
// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configurePoutes(router);
    Application.router = router;
    return Container(
      child: MaterialApp(
        title: '百姓生活+',
        onGenerateRoute: Application.router.generator,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.pink),
        home: IndexPage(),
      ),
    );
  }
}
