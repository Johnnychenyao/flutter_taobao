import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_taobao/common/model/search.dart';
import 'package:flutter_taobao/common/utils/common_utils.dart';
import 'package:flutter_taobao/common/utils/screen_util.dart';

class GZXSearchResultGridViewWidget extends StatelessWidget {
  final SearchResultListModel list;
  final ValueChanged<String> onItemTap;
  final VoidCallback getNextPage;
  BuildContext _context;

  GZXSearchResultGridViewWidget(this.list, {Key key, this.onItemTap, this.getNextPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _context = context;
    return list.data.length == 0
      ? Center(
          child: CircularProgressIndicator(),
        )
      : Padding(
          padding: EdgeInsets.only(left: 8, right: 8),
        );
  }

  Widget productGrid(List<SearchResultItemModel> data) => GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: MediaQuery.of(_context).orientation == Orientation.portrait ? 2 : 3,
      crossAxisSpacing: 8, // 左右间隔
      mainAxisSpacing: 8, // 上下间隔
      childAspectRatio: 3 / 4, //宽高比，默认1
    ),
    itemCount: list.data.length,
    itemBuilder: (BuildContext context, int index) {
      var product = list.data[index];
      if ((index + 4) == list.data.length) {
        print('SearchResultGridViewWidget.productGrid next page,current data count ${data.length},current index $index');
        getNextPage();
      }

      return Container(
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(),
                    child: CachedNetworkImage(
                      fadeInDuration: Duration(milliseconds: 0),
                      fadeOutDuration: Duration(milliseconds: 0),
                      fit: BoxFit.fill,
                      imageUrl: product.imageUrl,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 0, left: 8, bottom: 0, right: 8),
                  child: Text(
                    product.wareName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: ScreenUtil().setSp(12)),
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: <Widget>[
                    product.coupon == null
                      ? SizedBox()
                      : Container(
                          margin: EdgeInsets.only(top: 0, right: 8, bottom: 0, left: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            border: Border.all(width: 1, color: Color(0xFFff692d))
                          ),
                          child: Text(
                            product.coupon,
                            style: TextStyle(color: Color(0xFFff692d), fontSize: ScreenUtil().setSp(10)),
                          ),
                        ),
                    Container(
                      margin: EdgeInsets.only(top: 0, left: 8, bottom: 0, right: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3)),
                        border: Border.all(width: 1, color: Color(0xFFffd589))
                      ),
                    )
                  ],
                ),
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 5),
                    Text(
                      '￥',
                      style: TextStyle(fontSize: ScreenUtil().setSp(10), color: Color(0xFFff5410)),
                    ),
                    Text(
                      CommonUtils.removeDecimalZeroFormat(double.parse(product.price)),
                      style: TextStyle(fontSize: ScreenUtil().setSp(16), color: Color(0xFFff5410)),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '${product.commentcount}人评价',
                        style: TextStyle(fontSize: ScreenUtil().setSp(10), color: Color(0xFF979896)),
                      ),
                    ),
                    Icon(
                      Icons.more_horiz,
                      size: 15,
                      color: Color(0xFF979896),
                    ),
                    SizedBox(width: 8),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}