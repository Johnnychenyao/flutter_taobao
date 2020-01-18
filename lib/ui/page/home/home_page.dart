import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_taobao/common/data/home.dart';
import 'package:flutter_taobao/common/model/kingkong.dart';
import 'package:flutter_taobao/common/model/product.dart';
import 'package:flutter_taobao/common/model/tab.dart';
import 'package:flutter_taobao/common/services/search.dart';
import 'package:flutter_taobao/common/style/variables.dart';
import 'package:flutter_taobao/common/utils/log_util.dart';
import 'package:flutter_taobao/common/utils/navigator_utils.dart';
import 'package:flutter_taobao/common/utils/screen_util.dart';
import 'package:flutter_taobao/ui/page/home/searchlist_page.dart';
import 'package:flutter_taobao/ui/tools/arc_clipper.dart';
import 'package:flutter_taobao/ui/widget/gzx_tabber.dart';
import 'package:flutter_taobao/ui/widget/gzx_topbar.dart';
import 'package:flutter_taobao/ui/widget/menue.dart';
import 'package:flutter_taobao/ui/widget/recommend_floor.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomePage>{

  AnimationController _animationController;
  ScrollController _scrollViewController;
  TabController _controller;
  int _currentIndex = 0;
  List<TabModel> _tabModels = [];
  List _hotWords = [];
  Size _sizeRed;
  GlobalKey _keyFilter = GlobalKey();
  List<KingKongItem> kingKongItems;

  String get hoursString {
    Duration duration = _animationController.duration * _animationController.value;
    return '${(duration.inHours)..toString().padLeft(2, '0')}';
  }

  String get minutesString {
    Duration duration = _animationController.duration * _animationController.value;
    return '${(duration.inMinutes % 60).toString().padLeft(2, '0')}';
  }

  String get secondsString {
    Duration duration = _animationController.duration * _animationController.value;
    return '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void initData() async{
    List querys = await getHotSugs();
    setState(() {
      _hotWords = querys;
      print('hotwords；$_hotWords');
    });
  } 

  void _afterLayout(_) {
    _getSizes('_keyFilter', _keyFilter);
  }

  void _getSizes(log, GlobalKey globalKey) {
    RenderBox renderBoxRed = globalKey.currentContext.findRenderObject();
    _sizeRed = renderBoxRed.size;
    setState(() {});
    print('SIZE of $log: $_sizeRed');
  }

  @override
  void initState() { 
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    kingKongItems = KingKongList.fromJson(menueDataJson['items']).items;
    
    _tabModels.add(TabModel(title: '全部', subtitle: '猜你喜欢'));
    _tabModels.add(TabModel(title: '直播', subtitle: '网红推荐'));
    _tabModels.add(TabModel(title: '便宜好货', subtitle: '低价抢购'));
    _tabModels.add(TabModel(title: '买家秀', subtitle: '购后分享'));
    _tabModels.add(TabModel(title: '全球', subtitle: '进口好货'));
    _tabModels.add(TabModel(title: '生活', subtitle: '享受生活'));
    _tabModels.add(TabModel(title: '母婴', subtitle: '母婴大赏'));
    _tabModels.add(TabModel(title: '时尚', subtitle: '时尚好货'));

    //倒计时
    _animationController = AnimationController(vsync: this, duration: Duration(hours: 10, minutes: 30, seconds: 0));
    _animationController.reverse(from: _animationController.value == 0.0 ? 1.0 : _animationController.value);

    initData();

    _controller = TabController(vsync: this, length: 8);
    _controller.addListener(_handleTabSelection);

    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
  }

  @override
  void dispose() { 
    _scrollViewController.dispose();

    super.dispose();
  }

  // 切换tabBar方法
  void _handleTabSelection() {
    print('_handleTabSelection:${_controller.index}');
    setState(() {
      _currentIndex = _controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    /**组件列表 */
    var v = Column(
      children: <Widget>[
        _buildHotSearchWidget(),
        _buildSwiperImageWidget(),
        _buildSwiperButtonWidget(),
        _buildRecommendedCard(),
        _buildAdvertisingWidget(),
      ],
    );

    // 首页总tabBar
    var body = NestedScrollView(
      controller: _scrollViewController,
      headerSliverBuilder: (BuildContext context, bool boxIsScrolled){
        return <Widget>[
          SliverAppBar(
            pinned: true,
            floating: true,
            forceElevated: boxIsScrolled,
            backgroundColor: GZXColors.mainBackgroundColor,
            // backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: SingleChildScrollView( /* BUG: 修复溢出问题 */
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[v],
                ),
              ),
            ),
            expandedHeight: (_sizeRed == null ? ScreenUtil.screenHeight : _sizeRed.height) + 50.0,
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 46), // 46，限制了浮窗高度
              child: GZXTabBarWidget(
                tabControllerl: _controller,
                tabModelsl: _tabModels,
                currentIndex: _currentIndex,
              ),
            ),
          )
        ];
      },
      // body: _hotWords.length == 0
      //   ? Center(
      //       child: CircularProgressIndicator(),
      //     )
      //   : TabBarView(
      //       controller: _controller,
      //       children: _searchResultListPages(),
      //     ),
      body: TabBarView(
        controller: _controller,
        children: _searchResultListPages(),
      ),
    );

    /**主体 */
    return Scaffold(
      backgroundColor: GZXColors.mainBackgroundColor,
      appBar: PreferredSize(
          child: AppBar(
            brightness: Brightness.dark,
            elevation: 0,
          ),
          preferredSize: Size.fromHeight(0)
      ),
      body: Column(
        children: <Widget>[
          Offstage(
            offstage: true,
            child: Container(
              child: v,
              key: _keyFilter,
            ),
          ),
          GZXTopBar(
            searchHintTexts: searchHintTexts,
          ),
          Expanded(child: body),
        ],
      )
    );
  }

  /* 热搜 */
  Widget _buildHotSearchWidget(){
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Text(
            '热搜：',
            style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(13)),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                children: searchHintTexts.map((String item) => GestureDetector(
                  onTap: (){
                    NavigatorUtils.gotoSearchGoodsResultPage(context, item);
                  },
                  child: Container(
                    margin: EdgeInsets.all(4),
                    height: 20,
                    child: Material(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xFFfe8524),
                      child: Padding(
                        padding: EdgeInsets.only(left: 8, right: 8),
                        child: Center(
                          child: Text(
                            item,
                            style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(13)),
                          ),
                        ),
                      ),
                    ),
                  ),
                )).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _searchResultListPages() {
    List<Widget> pages = [];
    for (var i = 0; i < 8; i++) {
      var page=  SearchResultListPage(
        // _hotWords[i],
        'T恤',
        onNotification: _onScroll,
        isList: false,
        isRecommended: true,
      );
      pages.add(page);
    }
    return pages;
  }

  bool _onScroll(ScrollNotification scroll) {
    return false;
  }

  /* 轮播图 */
  Widget _buildSwiperImageWidget() {
    return Container(
      height: 150,
      child: ClipPath(
        clipper: new ArcClipper(),
        child: Swiper(
          index: 0, // 初始的时候下标位置
          loop: true, // 无线轮播模式开关
          itemCount: banner_images.length, // 轮播图图片数
          autoplay: true, // 自动播放开关
          duration: 300, // 动画时间，毫秒
          scrollDirection: Axis.horizontal, // 滚动方向，设置为Axis.vertical如果需要垂直滚动
          itemBuilder: (context, index){
            return GestureDetector(
              onTap:() {},
              child: Container(
                height: 150,
                child: Stack(
                    children: <Widget>[
                      Container(
                        height: 150,
                        child: CachedNetworkImage(
                          fadeOutDuration: Duration(milliseconds: 200),
                          fadeInDuration: Duration(milliseconds: 500),
                          fit: BoxFit.fill,
                          imageUrl: banner_images[index],
                          errorWidget: (context, url, error) => new Icon(Icons.error),
                        ),
                      )
                    ],
                ),
              ),
            );
          },
          pagination: SwiperPagination(), // 默认分页指示器
          onTap: (index) {
            LogUtil.v("你点击了第$index个");
            print("你点击了第$index个");
          },
        ),
      ),
    );
  }

  /* 快捷入口 */
  Widget _buildSwiperButtonWidget(){
    return Container(
      height: ScreenUtil().L(80) * 2 + 15,
      child: Swiper(
        index: 0, // 初始的时候下标位置
        loop: true,
        autoplay: false,
        duration: 300,
        scrollDirection: Axis.horizontal,
        itemCount: (kingKongItems.length / 10).toInt() + (kingKongItems.length % 10 > 0 ? 1 : 0), // 翻页数
        itemBuilder: (context, index){
          List data = [];
          for (var i = (index * 2) * 5; i < (index * 2) * 5 + 5; i++) {
            // 0-4,10-14
            if (i >= kingKongItems.length) {
              break;
            }
            data.add(kingKongItems[i]);
          }
          List data1 = [];
          for (var i = (index * 2 + 1) * 5; i < (index * 2 + 1) * 5 + 5; i++) {
            //5-9,15-19
            if (i >= kingKongItems.length) {
              break;
            }
            data1.add(kingKongItems[i]);
          }

          return Column(
            children: <Widget>[
              HomeKingKongWidget(
                data: data,
                fontColor: (menueDataJson['config'] as dynamic)['color'],
                bgurl: (menueDataJson['config'] as dynamic)['pic_url'],
              ),
              HomeKingKongWidget(
                data: data1,
                fontColor: (menueDataJson['config'] as dynamic)['color'],
                bgurl: (menueDataJson['config'] as dynamic)['pic_url'],
              ),
            ],
          );
        },
        pagination: SwiperPagination( // 分页指示器
          alignment: Alignment.bottomCenter,
          builder: RectSwiperPaginationBuilder(
            color: Color(0xFFd3d7de),
            activeColor: Theme.of(context).primaryColor,
            size: Size(18, 3),
            activeSize: Size(18, 3),
            space: 0
          )
        ),
      ),
    );
  }

  /* 推荐橱窗 */
  Widget _buildRecommendedCard() {
    Positioned unReadMsgCountText = Positioned(
      top: 10,
      left: 60,
      child: Container(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (_, Widget child){
            return Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    color: Colors.red,
                    child: Text(
                      hoursString,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(
                  ':',
                  style: TextStyle(color: Colors.red),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    color: Colors.red,
                    child: Text(
                      minutesString,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(
                  ':',
                  style: TextStyle(color: Colors.red),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    color: Colors.red,
                    child: Text(
                      secondsString,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      )
    );

    return Padding(
      padding: EdgeInsets.all(6),
      child: Card(
        shape: RoundedRectangleBorder( // 设置shape，这里设置成了R角
          borderRadius: BorderRadius.all(Radius.circular(16.0))
        ),
        clipBehavior: Clip.antiAlias, // 对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
        child: Padding(
          padding: EdgeInsets.all(3),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  RecommendFloor(ProductListModel.fromJson(recommendJson)),
                  unReadMsgCountText
                ],
              ),
              Container(
                width: ScreenUtil.screenWidth,
                height: 0.7,
                color: GZXColors.mainBackgroundColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /* 广告 */
  Widget _buildAdvertisingWidget() {
    return Container(
      margin: EdgeInsets.only(top: 0, left: 8, bottom: 10, right: 8),
      height: 80,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'static/images/618.png',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}