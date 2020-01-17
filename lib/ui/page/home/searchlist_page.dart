import 'package:flutter/material.dart';
import 'package:flutter_taobao/common/model/search.dart';
import 'package:flutter_taobao/common/services/search.dart';
import 'package:flutter_taobao/common/style/variables.dart';
import 'package:flutter_taobao/common/utils/screen_util.dart';
import 'package:flutter_taobao/ui/widget/gzx_searchresult_gridview_widget.dart';
import 'package:flutter_taobao/ui/widget/gzx_searchresult_list_widget.dart';

class GoodsSortCondition {
  String name;
  bool isSelected;

  GoodsSortCondition({this.name, this.isSelected});
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

class _SearchResultListPageState extends State<SearchResultListPage> with AutomaticKeepAliveClientMixin<SearchResultListPage>, SingleTickerProviderStateMixin {

  SearchResultListModel listData = SearchResultListModel([]);
  int page = 0;
  bool _isList;
  bool _isShowMask = false;
  bool _isShowDropDownItemWidget = false;
  GlobalKey _keyFilter = GlobalKey();
  GlobalKey _keyDropDownItem = GlobalKey();

  var _dropDownItem;
  double _dropDownHeight = 0;
  Animation<double> _animation;
  AnimationController _animationController;
  List _filterConditions = ['综合','信用','价格降序','价格升序'];
  List<GoodsSortCondition> _goodsSortConditions = [];
  GoodsSortCondition _selectGoodsSortCondition;

  _SearchResultListPageState();

  @override
  void initState() {
    getSearchList(widget.keyword);
    super.initState();

    _isList = widget.isList;

    // 初始化动画控制器
    _animationController = new AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _goodsSortConditions.add(GoodsSortCondition(name: '综合', isSelected: true));
    _goodsSortConditions.add(GoodsSortCondition(name: '信用', isSelected: false));
    _goodsSortConditions.add(GoodsSortCondition(name: '价格降序', isSelected: false));
    _goodsSortConditions.add(GoodsSortCondition(name: '价格升序', isSelected: false));

    _selectGoodsSortCondition = _goodsSortConditions[0];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _dropDownItem = ListView.separated(
      shrinkWrap: true, // 遗留问题，什么效果
      scrollDirection: Axis.vertical,
      itemCount: _goodsSortConditions.length,
      separatorBuilder: (BuildContext context, int index) => Divider(height: 1.0), // 添加分割线
      itemBuilder: (BuildContext context, int index) {
        GoodsSortCondition goodsSortCondition = _goodsSortConditions[index];

        return GestureDetector(
          onTap: (){
            for (var item in _goodsSortConditions) {
              item.isSelected = false;
            }
            goodsSortCondition.isSelected = true;
            _selectGoodsSortCondition = goodsSortCondition;

            _hideDropDownItemWidget();
          },
          child: Container(
            height: 40,
            child: Row(
              children: <Widget>[
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    goodsSortCondition.name,
                    style: TextStyle(
                      color: goodsSortCondition.isSelected ? Colors.red : Colors.black
                    ),
                  ),
                ),
                goodsSortCondition.isSelected
                  ? Icon(
                      Icons.check,
                      color: Theme.of(context).primaryColor,
                      size: 16,
                    )
                  : SizedBox(),
                SizedBox(width: 16),
              ],
            ),
          ),
        );
      },
    );

    var hideWidget = Container(
      color: Colors.red,
      key: _keyDropDownItem,
      child: _dropDownItem,
    );

    var resultWidget = _isList
      ? GZXSearchResultListWidget(listData, getNextPage: () => getSearchList(widget.keyword))
      : GZXSearchResultGridViewWidget(listData, getNextPage: () => getSearchList(widget.keyword));

    if (widget.isRecommended) {
      return resultWidget;
    }

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

  void _showDropDownItemWidget() {
    // final RenderBox dropDownItemRenderBox = _keyDropDownItem.currentContext.findRenderObject();

    _dropDownHeight = 160;
    _isShowDropDownItemWidget = !_isShowDropDownItemWidget;
    _isShowMask = !_isShowMask;

    _animation = new Tween(begin: 0.0, end: _dropDownHeight).animate(_animationController)
      ..addListener(() { // 如果这行不写，没有动画效果!!!
        setState(() {});
      });

    if (_animation.status == AnimationStatus.completed) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
  }

  void _hideDropDownItemWidget() {
    _isShowDropDownItemWidget = !_isShowDropDownItemWidget;
    _isShowMask = !_isShowMask;
    _animationController.reverse();
  }

  Widget _buildFilterWidget() {
    return Column(
      key: _keyFilter,
      children: <Widget>[
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () {
                  _showDropDownItemWidget();
                },
                child: Row(
                  children: <Widget>[
                    Text(
                      _selectGoodsSortCondition.name,
                      style: TextStyle(fontSize: ScreenUtil().setSp(14), color: Colors.red),
                    ),
                    Icon(
                      !_isShowDropDownItemWidget ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                      color: Colors.red,
                    )
                  ],
                ),
              ),
            ),
            Text(
              '销量',
              style: TextStyle(fontSize: ScreenUtil().setSp(14)),
            ),
            Row(
              children: <Widget>[
                Text(
                  '视频',
                  style: TextStyle(fontSize: ScreenUtil().setSp(14)),
                ),
                Icon(
                  GZXIcons.video,
                  size: 14,
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isList = !_isList;
                });
              },
              child: Container(
                width: 36,
                height: 34,
                child: Icon(
                  _isList ? GZXIcons.list : GZXIcons.cascades,
                  size: 18,
                ),
              ),
            ),
            GestureDetector(
              onTap: widget.onTapfilter,
              child: Padding(
                padding: EdgeInsets.only(right: 20),
                child: Row(
                  children: <Widget>[
                    Text(
                      '筛选',
                      style: TextStyle(fontSize: ScreenUtil().setSp(14)),
                    ),
                    Icon(
                      GZXIcons.filter,
                      size: 16,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildDrapDownWidget() {
    RenderBox renderBoxRed;
    double top = 0;
    if (_dropDownHeight != 0) {
      renderBoxRed = _keyFilter.currentContext.findRenderObject();
      top = renderBoxRed.size.height;
    }

    return Positioned(
      width: MediaQuery.of(context).size.width,
      top: top,
      left: 0,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: _animation == null ? 0 : _animation.value,
            child: _dropDownItem,
          ),
          _isShowMask
            ? GestureDetector(
                onTap: (){
                  _hideDropDownItemWidget();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                ),
              )
            : Container(
                height: 0
              )
        ],
      ),
    );

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}