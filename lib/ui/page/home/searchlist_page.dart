import 'package:flutter/material.dart';
import 'package:flutter_taobao/common/model/search.dart';
import 'package:flutter_taobao/common/services/search.dart';
import 'package:flutter_taobao/common/style/variables.dart';
import 'package:flutter_taobao/ui/widget/gzx_searchresult_gridview_widget.dart';
import 'package:flutter_taobao/ui/widget/gzx_searchresult_list_widget.dart';

class GoodsSortCondition {
  String name;
  bool isSelected;

  GoodsSortCondition({this.name, this.isSelected}) {}
}

class SearchResultListPage<T extends ScrollNotification> extends StatefulWidget {
  final String keyword;
  final bool isList;
  final bool isShowFilterWidget;
  final VoidCallback onTapfilter;
  final NotificationListenerCallback<T> onNotification;
  final bool isRecommended;

  SearchResultListPage(this.keyword, 
    {
      this.isList = false,
      this.onTapfilter,
      this.isShowFilterWidget = false,
      this.onNotification,
      this.isRecommended = false
    });

  @override
  _SearchResultListPageState createState() => _SearchResultListPageState();
}

class _SearchResultListPageState extends State<SearchResultListPage> {

  SearchResultListModel listData = SearchResultListModel([]);
  bool _isList;
  int page = 0;

  @override
  void initState() {
    super.initState();

    _isList = widget.isList;
  }

  @override
  Widget build(BuildContext context) {

    var hideWidget = Container(
    );

    var resultWidget = _isList
      ? GZXSearchResultListWidget(listData, getNextPage: () => getSearchList(widget.keyword),)
      : GZXSearchResultGridViewWidget(listData, getNextPage: () => getSearchResult(widget.keyword),);

    return Scaffold(
      backgroundColor: GZXColors.mainBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16)
          ),
          color: Colors.white
        ),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                widget.isShowFilterWidget 
                  ? _buildFilterWidget()
                  : SizedBox(),
                Offstage(
                  child: hideWidget,
                  offstage: true,
                ),
                Expanded(
                  child: Container(
                    color: _isList ? Colors.white : GZXColors.mainBackgroundColor,
                    child: NotificationListener<ScrollNotification>(  /* 遗留问题？？？什么功能 */
                      onNotification: _onScroll,
                      child: resultWidget,
                    ),
                  ),
                )
              ],
            ),
            _buildDrapDownWidget()
          ],
        ),
      ),
    );
  }

  bool _onScroll(ScrollNotification scroll) {
    if (widget.onNotification != null) {
      widget.onNotification(scroll);
    }
    // 当前滑动距离
    double currentExtent = scroll.metrics.pixels;
    double maxExtent = scroll.metrics.maxScrollExtent;
    print('SearchResultListState._onScroll $currentExtent $maxExtent');
    return false;
  }

  void getSearchList(String keyword) async{
    var data = await getSearchResult(keyword, page++);
    SearchResultListModel list = SearchResultListModel.fromJson(data);
    print('mounted:$mounted');
    if (mounted) {
      setState(() {
        listData.data.addAll(list.data);
      });
    }
  }

  Widget _buildFilterWidget() {

  }

  Widget _buildDrapDownWidget() {
    
  }
}