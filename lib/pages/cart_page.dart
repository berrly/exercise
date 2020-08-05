import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';
import './cart_page/cart_item.dart';
import './cart_page/cart_bottom.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('购物车'),
        ),
        body: FutureBuilder(
          future: _getCartInfo(context),
          builder: (context, snapshot) {
            List cartList = Provider.of<CartProvider>(context).cartList;
            if (snapshot.hasData) {
              return Stack(
                children: <Widget>[
                  Consumer<CartProvider>(
                      builder: (context, CartProvider info, child) {
                    List cartList =
                        Provider.of<CartProvider>(context, listen: false)
                            .cartList;
                    return ListView.builder(
                        itemCount: cartList.length,
                        itemBuilder: (context, index) {
                          return CartItem(cartList[index]);
                        });
                  }),
                  Positioned(bottom: 0, left: 0, child: CartBottom()),
                ],
              );
            } else {
              return Text('加载中');
            }
          },
        ));
  }

  Future _getCartInfo(context) async {
    await Provider.of<CartProvider>(context, listen: false).getCartInfo();
    return '收到';
  }
}
