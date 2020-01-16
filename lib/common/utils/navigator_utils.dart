import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_taobao/ui/page/home/search_goods_page.dart';
import 'package:flutter_taobao/ui/page/home/search_goods_result_page.dart';

class NavigatorUtils {
  static gotoSearchGoodsPage(BuildContext context, {String keywords}) {
    return Navigator.of(context).push(new MyCupertinoPageRoute(SearchGoodsPage(
      keywords: keywords
    )));
  }

  static gotoSearchGoodsResultPage(BuildContext context, String keywords) {
    NavigatorRouter(context, SearchGoodsResultPage(keywords: keywords));
  }

  static NavigatorRouter(BuildContext context, Widget widget) {
    return Navigator.push(context, CupertinoPageRoute(builder: (context) => widget));
  }
}

class MyCupertinoPageRoute extends CupertinoPageRoute {
  Widget widget;

  MyCupertinoPageRoute(this.widget) : super(builder: (BuildContext context) => widget);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return new FadeTransition(opacity: animation, child: widget);
  }

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration(seconds: 0);
}