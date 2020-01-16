import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_taobao/common/data/home.dart';
import 'package:flutter_taobao/common/style/variables.dart';
import 'package:flutter_taobao/common/utils/screen_util.dart';

class GZXSearchCardWidget extends StatefulWidget {
  final FocusNode focusNode;
  TextEditingController textEditingController;
  final VoidCallback onTap;
  final bool isShowLeading;
  final String hintText;
  final ValueChanged<String> onSubmitted;
  final ValueChanged<String> onChanged;
  final bool autofocus;
  final bool isShowSuffixIcon;
  final double elevation;
  Widget rightWidget;

  GZXSearchCardWidget({
    Key key,
    this.focusNode,
    this.textEditingController,
    this.onTap,
    this.isShowLeading = true,
    this.onSubmitted,
    this.onChanged,
    this.autofocus = false,
    this.isShowSuffixIcon = true,
    this.hintText,
    this.elevation = 2.0,
    this.rightWidget
  }) : super(key: key);

  @override
  _GZXSearchCardWidgetState createState() => _GZXSearchCardWidgetState();
}

class _GZXSearchCardWidgetState extends State<GZXSearchCardWidget> {
  String _hintText;
  Widget _rightWidget;

  @override
  void initState() { 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _rightWidget = widget.rightWidget;
    _rightWidget ??=Icon(
      GZXIcons.camera,
      color: Colors.grey,
      size: 20,
    );
    _hintText = widget.hintText;
    _hintText ??= searchHintTexts[Random().nextInt(searchHintTexts.length)];
    if (widget.textEditingController == null) {
      widget.textEditingController = TextEditingController();
    }

    return _searchCard();
  }

  Widget _textField() => Expanded(
    child: Container(
      height: 34,
      child: TextField(
        autofocus: widget.autofocus,
        onTap: widget.onTap,
        focusNode: widget.focusNode,
        style: TextStyle(fontSize: ScreenUtil().setSp(13)),
        controller: widget.textEditingController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 0),
          border: InputBorder.none,
          hintText: _hintText,
          suffixIcon: widget.textEditingController.text.length == 0 || !widget.isShowSuffixIcon
            ? SizedBox()
            : Container(
                width: 20,
                height: 20,
                alignment: Alignment.centerRight,
                child: IconButton(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 6),
                  iconSize: 18.0,
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.grey[500],
                    size: 16,
                  ),
                  onPressed: (){
                    setState(() {
                      widget.textEditingController.text = '';
                      widget.onChanged('');
                    });
                  },
                ),
              ),
        ),
        onSubmitted: widget.onSubmitted,
        onChanged: widget.onChanged,
      ),
    ),
  );

  Widget _searchCard() => Padding(
    // padding: EdgeInsets.only(top: 8, bottom: 8),
    padding: EdgeInsets.only(top: 0, right: 0),
    child: Card(
      elevation: widget.elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))), // 设置圆角
      child: Padding(
        padding: EdgeInsets.only(top: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            widget.isShowLeading
              ? Padding(
                  padding: EdgeInsets.only(top: 0,right: 5, left: 5),
                  child: Icon(
                    GZXIcons.search_light,
                    color: Colors.grey,
                    size: 20,
                  ),
                )
              : SizedBox(
                  width: 10,
                ),
            _textField(),
            widget.textEditingController.text.length == 0 || !widget.isShowSuffixIcon
              ? Padding(padding: EdgeInsets.only(right: 5), child: _rightWidget,)
              : SizedBox(),
          ],
        ),
      ),
    ),
  );

}