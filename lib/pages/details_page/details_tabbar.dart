import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/details_info.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailsTarbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DetailsInfo>(builder: (context, DetailsInfo data, child) {
      var isLeft = Provider.of<DetailsInfo>(context, listen: false).isLeft;
      var info = Provider.of<DetailsInfo>(context, listen: false)
          .goodsInfo
          .data
          .goodInfo
          .goodsDetail;

      if (isLeft) {
        return Container(
          child: Html(data: info),
        );
      } else {
        return Container(
          child: Text('暂无评论'),
        );
      }
    });
  }
}
