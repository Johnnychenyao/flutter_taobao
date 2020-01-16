import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_taobao/common/model/search.dart';
import 'package:flutter_taobao/common/style/variables.dart';
import 'package:flutter_taobao/common/utils/common_utils.dart';
import 'package:flutter_taobao/common/utils/screen_util.dart';

class GZXSearchResultListWidget extends StatelessWidget {
  final SearchResultListModel list;
  final ValueChanged<String> onItemTap;
  final VoidCallback getNextPage;

  GZXSearchResultListWidget(this.list, {this.onItemTap, this.getNextPage});

  @override
  Widget build(BuildContext context) {
    return list.data.length == 0
      ? Center(
          child: CircularProgressIndicator(),
        )
      : ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 10),  // 遗留问题： 什么效果
          itemCount: list.data.length,
          itemExtent: ScreenUtil().L(127), // 遗留问题： 什么效果
          itemBuilder: (BuildContext context, int index){
            SearchResultItemModel item = list.data[index];

            if ((index + 3) == list.data.length) {
              print('SearchResultListWidget.build next page,current data count ${list.data.length}');
              getNextPage();
            }
            return Container(
              color: GZXColors.searchAppBarBgColor,
              padding: EdgeInsets.only(top: ScreenUtil().L(5), right: ScreenUtil().L(10)),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      fadeInDuration: Duration(milliseconds: 0),
                      fadeOutDuration: Duration(milliseconds: 0),
                      fit: BoxFit.fill,
                      imageUrl: item.imageUrl,
                      width: ScreenUtil().L(120),
                      height: ScreenUtil().L(120),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 1, color: GZXColors.divideLineColor)
                        )
                      ),
                      child: _buildContent(item),
                    ),
                  )
                ],
              ),
            );
          },
        );
  }

  Widget _buildContent(SearchResultItemModel item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          item.wareName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Row(
          children: <Widget>[
            item.coupon == null
              ? SizedBox()
              : Container(
                  margin: EdgeInsets.only(top: 0, left: 8, bottom: 0, right: 0),
                  child: Text(
                    item.coupon,
                    style: TextStyle(color: Color(0xFFff692d), fontSize: ScreenUtil().setSp(10)),
                  ),
                ),
            Container(
              margin: EdgeInsets.only(top: 0, left: 8, bottom: 0, right: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(3)),
                border: Border.all(width: 1, color: Color(0xFFffd589))
              ),
              child: Text(
                '包邮',
                style: TextStyle(color: Color(0xFFfebe35), fontSize: ScreenUtil().setSp(10)),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(width: 5),
            Text(
              '￥',
              style: TextStyle(fontSize: ScreenUtil().setSp(10), color: Color(0xFFff5410)),
            ),
            Text(
              // '27.5'
              '${CommonUtils.removeDecimalZeroFormat(double.parse(item.price))}',
              style: TextStyle(fontSize: ScreenUtil().setSp(16), color: Color(0xFFff5410)),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                '${item.commentcount}人评价',
                style: TextStyle(fontSize: ScreenUtil().setSp(10), color: Color(0xFF979896)),
              ),
            ),
            SizedBox(width: 8)
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Flexible( // 遗留问题： 什么效果
                    child: Text(
                      '${item.shopName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GZXConstant.searchResultItemCommentCountStyle,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text('进店', style: TextStyle(fontSize: ScreenUtil().setSp(12))),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.chevron_left,
                      size: 18,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.more_horiz,
                size: 15,
                color: Color(0xFF979896),
              ),
            )
          ],
        )
      ],
    );
  }
}