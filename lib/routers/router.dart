import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import './router_handle.dart';

class Routes {
  static String root = '/';
  static String detailPage = '/detail';
  static void configurePoutes(Router router) {
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext context, Map<String, dynamic> params) {
        print('ErrOR');
      },
    );
    router.define(detailPage, handler: detailsHandler);
  }
}
