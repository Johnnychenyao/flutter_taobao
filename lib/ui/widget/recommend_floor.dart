import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_taobao/common/model/product.dart';
import 'package:flutter_taobao/common/utils/common_utils.dart';
import 'package:flutter_taobao/common/utils/screen_util.dart';

class RecommendFloor extends StatelessWidget {
  final ProductListModel data;

  RecommendFloor(this.data);

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      child: _build(deviceWidth),
    );
  }

  Widget _build(double deviceWidth) {
    List<ProductItemModel> items = data.items;

    deviceWidth -= 28;
    double itemWidth = deviceWidth / 4;
    double imageWidth = deviceWidth / 4;

    List<Widget> listWidgets = items.map((i) {
      // var bgColor = CommonUtils.string2Color(i.bgColor);
      // Color titleColor = CommonUtils.string2Color(i.titleColor);
      // Color subtitleColor = CommonUtils.string2Color(i.subtitleColor);

      return Container(
        width: itemWidth,
        padding: EdgeInsets.only(top: 8, left: 3, bottom: 7, right: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _gridTitle(i),
            _gridImage(i, imageWidth)
          ],
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: 0,
          children: listWidgets,
        )
      ],
    );
  }

  /* 小格子标题 */
  Widget _gridTitle(ProductItemModel item) {
    Color titleColor = CommonUtils.string2Color(item.titleColor);

    return Container(
      height: 25,
      child: Text(
        item.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(15),fontWeight: FontWeight.bold, color: titleColor),
      ),
    );
  }

  /* 小格子主体-子标题+图片 */
  Widget _gridImage(ProductItemModel item, double imageWidth) {
    var bgColor = CommonUtils.string2Color(item.bgColor);
    Color subtitleColor = CommonUtils.string2Color(item.subtitleColor);

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: bgColor,
        child: Column(
          children: <Widget>[
            SizedBox(height: 4),
            Text( 
              item.subtitle,
              maxLines: 1,
              style: TextStyle(color: subtitleColor, fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(12)),
            ),
            Container(
              alignment: Alignment(0, 0),
              // margin: EdgeInsets.only(top: 5), // BUG: 生效后，溢出了
              child: CachedNetworkImage(
                imageUrl: item.picurl,
                width: imageWidth,
                height: imageWidth + 20,
              ),
            )
          ],
        ),
      ),
    );
  }

}