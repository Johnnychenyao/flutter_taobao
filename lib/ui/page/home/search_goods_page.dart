import 'package:flutter/material.dart';
import 'package:flutter_taobao/common/style/variables.dart';
import 'package:flutter_taobao/common/utils/navigator_utils.dart';
import 'package:flutter_taobao/common/utils/screen_util.dart';
import 'package:flutter_taobao/ui/widget/gzx_search_card.dart';
import 'package:flutter_taobao/ui/widget/recomend_search.dart';

class SearchGoodsPage extends StatefulWidget {
  final String keywords;

  SearchGoodsPage({Key key, this.keywords}) : super(key: key);

  @override
  _SearchGoodsPageState createState() => _SearchGoodsPageState();
}

class _SearchGoodsPageState extends State<SearchGoodsPage> {
  List _tabsTitle = ['全部', '天猫', '店铺'];
  List<String> recomendWords = [];
  TextEditingController _keywordsTextEditingController = TextEditingController();

  @override
  void initState() { 
    super.initState();
    
    _keywordsTextEditingController.text = widget.keywords;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GZXColors.mainBackgroundColor,
      appBar: PreferredSize( // 遗留问题，什么效果
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          brightness: Brightness.light,
          backgroundColor: GZXColors.mainBackgroundColor,
          elevation: 0,
        ),
      ),
      body: DefaultTabController(
        length: 3,
        initialIndex: 0,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: GZXSearchCardWidget(
                    elevation: 0,
                    autofocus: true,
                    textEditingController: _keywordsTextEditingController,
                    isShowLeading: false,
                    onSubmitted: (value){
                      NavigatorUtils.gotoSearchGoodsResultPage(context, value);
                    },
                    onChanged: (value){
                      searchTxtChanged(value);
                    },
                  ),
                ),
                GestureDetector(
                  child: Text(
                    '取消',
                    style: TextStyle(fontSize: ScreenUtil().setSp(13)),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 8)
              ],
            ),
            Expanded(
              child: recomendWords.length == 0
                ? _buildContentWidget()
                : RecomendSearchWidget(recomendWords, onItemTap: (value) {
                    NavigatorUtils.gotoSearchGoodsResultPage(context, value);
                  })
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContentWidget() {
    return Container();
  }

  void searchTxtChanged(String q) async {
    // var result = await getSugg
  }
}