import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_taobao/common/utils/screen_util.dart';

class HomeKingKongWidget extends StatelessWidget {
  final List data;
  final String bgurl;
  final String fontColor;
  HomeKingKongWidget({this.data, this.bgurl, this.fontColor});

  @override
  Widget build(BuildContext context) {
    double _deviceWideh = MediaQuery.of(context).size.width;
    double _height = ScreenUtil().L(80);
    
    return Container(
      width: _deviceWideh,      
      height: _height,
      child: _buildRow(_deviceWideh),
      decoration: bgurl != ''
        ? BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(bgurl),
              fit: BoxFit.cover
            )
          )
        : null,
    );
  }

  Row _buildRow(double deviceWidth) {
    var colorInt = int.parse(fontColor.replaceAll('#', '0x'));
    Color color = new Color(colorInt).withOpacity(1.0);
    double iconWidth = ScreenUtil().L(58);
    double iconHeight = ScreenUtil().L(47);

    List<Widget> widgets = data.map((item) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CachedNetworkImage(
              width: iconWidth,
              height: iconHeight,
              imageUrl: item.picUrl,
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
            Text(
              item.title,
              style: TextStyle(
                fontSize: ScreenUtil().setSp(13),
                height: 1.5,
                decoration: TextDecoration.none,
                color: color
              ),
            )
          ],
        ),
      );
    }).toList();

    return Row(
      children: widgets,
    );
  }

}