import 'package:flutter/material.dart';
import 'package:flutter_taobao/common/style/variables.dart';
import 'package:flutter_taobao/common/utils/navigator_utils.dart';
import 'package:flutter_taobao/common/utils/screen_util.dart';
import 'package:flutter_taobao/ui/widget/gzx_search_card.dart';

class GZXTopBar extends StatelessWidget {
  TextEditingController _keywordTextEdittingController = TextEditingController();

  final List<String> searchHintTexts;

  GZXTopBar({Key key, this.searchHintTexts}) : super(key: key);

  FocusNode _focus = new FocusNode();

  BuildContext _context;

  void _onFocusChange() {
   print('HomeTopBar._onFocusChange:${_focus.hasFocus}');
   if(!_focus.hasFocus){
     return;
   }
  //  NavigatorUtils.gotoSearchGoodsPage(_context);
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    _focus.addListener(_onFocusChange);

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(top: statusBarHeight, left: 0, right: 0, bottom: 0),
      child: Row(
        children: <Widget>[
          _scanCode(),
          _searchCard(context),
          _qrCode()
        ],
      ),
    );
  }

  Widget _scanCode(){
    return Container(
      margin: EdgeInsets.only(right: 6.0, left: 4.0),
      width: 30,
      height: 34,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            GZXIcons.scan,
            color: Colors.white,
            size: 18,
          ),
          SizedBox(height: 3),
          Expanded(
            child: Text(
              '扫一扫',
              style: TextStyle(fontSize: ScreenUtil().setSp(8), color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget _searchCard(context){
    return Expanded(
      flex: 1,
      child: GZXSearchCardWidget(
        elevation: 5.0,
        onTap: (){
          FocusScope.of(context).requestFocus(FocusNode());
          NavigatorUtils.gotoSearchGoodsPage(context);
        },
        textEditingController: _keywordTextEdittingController,
        focusNode: _focus,
      ),
    );
  }

  Widget _qrCode(){
    return Container(
      margin: EdgeInsets.only(right: 4.0, left: 6.0),
      width: 30,
      height: 34,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            GZXIcons.qr_code,
            color: Colors.white,
            size: 18,
          ),
          SizedBox(height: 3),
          Expanded(
            child: Text(
              '会员码',
              style: TextStyle(fontSize: ScreenUtil().setSp(8), color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

}