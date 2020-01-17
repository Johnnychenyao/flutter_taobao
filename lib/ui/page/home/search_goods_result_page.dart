import 'package:flutter/material.dart';
import 'package:flutter_taobao/common/style/variables.dart';
import 'package:flutter_taobao/common/utils/navigator_utils.dart';
import 'package:flutter_taobao/common/utils/screen_util.dart';
import 'package:flutter_taobao/ui/page/home/searchlist_page.dart';
import 'package:flutter_taobao/ui/widget/gzx_search_card.dart';

class SearchGoodsResultPage extends StatefulWidget {
  final String keywords;

  SearchGoodsResultPage({Key key, this.keywords}) : super(key: key);

  @override
  _SearchGoodsResultPageState createState() => _SearchGoodsResultPageState();
}

class _SearchGoodsResultPageState extends State<SearchGoodsResultPage> {
  List _tabsTitle=  ['全部','天猫','店铺','淘宝经验'];
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController _keywordTextEditingController = TextEditingController();

  @override
  void initState() { 
    super.initState();
    
    _keywordTextEditingController.text = widget.keywords;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // endDrawer: GZXFilterGoodsPage(),
      backgroundColor: GZXColors.mainBackgroundColor,
      appBar: PreferredSize( // 遗留问题，什么作用
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          brightness: Brightness.light,
          backgroundColor: GZXColors.mainBackgroundColor,
          elevation: 0,
        ),
      ),
      body: DefaultTabController(
        length: 4,
        initialIndex: 0,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(width: 8),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(
                    GZXIcons.back_light,
                    size: 20,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GZXSearchCardWidget(
                    isShowLeading: false,
                    isShowSuffixIcon: false,
                    textEditingController: _keywordTextEditingController,
                    onTap: (){
                      NavigatorUtils.gotoSearchGoodsPage(context, keywords: widget.keywords);
                    },
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  children: <Widget>[
                    Container(
                      height: 16,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: Text(
                        '20',
                        style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(8)),
                      ),
                    ),
                    Container(
                      height: 20,
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.more_horiz,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8),
              ],
            ),
            SizedBox(height: 8),
            TabBar(
              indicatorColor: Color(0xFFfe5100),
              indicatorSize: TabBarIndicatorSize.label,
              // indicatorSize: TabBarIndicatorSize.tab,
              isScrollable: true,
              labelColor: Color(0xFFfe5100),
              unselectedLabelColor: Colors.black,
              labelPadding: EdgeInsets.only(left: 30, right: 30),
              onTap: (i){
                print('i:$i');
              },
              tabs: _tabsTitle.map((i) => 
                Text(i)
              ).toList(),
            ),
            SizedBox(height: 8),
            Expanded(
              child: TabBarView(
                children: _tabsTitle.map((item) => 
                  SearchResultListPage(
                    widget.keywords,
                    isList: true,
                    isShowFilterWidget: true,
                    onTapfilter: (){
                      _scaffoldKey.currentState.openEndDrawer(); // 遗留问题，什么效果
                    },
                  )
                ).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}