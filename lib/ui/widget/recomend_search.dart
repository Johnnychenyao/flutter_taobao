import 'package:flutter/material.dart';
import 'package:flutter_taobao/common/style/variables.dart';
import 'package:flutter_taobao/common/utils/screen_util.dart';

class RecomendSearchWidget extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String> onItemTap;

  RecomendSearchWidget(this.items,{this.onItemTap});

  @override
  Widget build(BuildContext context) {
    var listView = ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 6), // 遗留问题，什么效果
      itemCount: items.length,
      itemBuilder: (BuildContext context, int i){
        return InkWell(
          onTap: () => onItemTap(items[i]),
          child: Container(
            height: 42,
            alignment: Alignment.centerLeft,
            child: Row(
              children: <Widget>[
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    items[i],
                    style: TextStyle(fontSize: ScreenUtil().setSp(12)),
                  ),
                ),
                Icon(
                  GZXIcons.jump,
                  color: Colors.grey[400],
                ),
                SizedBox(width: 4),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int i) { // 分割符
        return Container(
          height: 1,
          color: Colors.grey[200],
        );
      },
    );

    return Container(
      decoration:  BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16)
        ),
        color: Colors.white
      ),
      child: listView,
    );
  }
}