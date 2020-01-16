import 'package:flutter/material.dart';
import 'package:flutter_taobao/common/model/tab.dart';

class GZXTabBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final List<TabModel> tabModelsl;
  final TabController tabControllerl;
  final int currentIndex;
  const GZXTabBarWidget({Key key, this.tabModelsl, this.tabControllerl, this.currentIndex}) : super(key: key);

  @override
  _GZXTabBarWidgetState createState() => _GZXTabBarWidgetState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(30);
}

class _GZXTabBarWidgetState extends State<GZXTabBarWidget> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: widget.tabControllerl,
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        isScrollable: true,
        labelColor: Color(0xFFfe5100),
        unselectedLabelColor: Colors.black,
        labelPadding: EdgeInsets.only(right: 5.0, left: 5.0),
        onTap: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
        tabs: widget.tabModelsl.map((item) => Container(
          padding: EdgeInsets.all(0),
          height: 44.0,
          child: new Tab(
            child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(height: 3,),
                    Text(item.title),
                    SizedBox(height: 3,),
                    widget.tabModelsl.indexOf(item) == widget.currentIndex
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Container(
                            padding: EdgeInsets.all(2),
                            color: Color(0xFFfe5100),
                            child: Text(
                              item.subtitle,
                              style: TextStyle(fontSize: 9, color: Colors.white)
                            ),
                          ),
                        )
                      : Expanded(
                          child: Text(
                            item.subtitle,
                            style: TextStyle(fontSize: 9, color: Color(0xFFb5b6b5)),
                          ),
                        )
                  ],
                )
              ],
            ),
          ),
        )).toList(),
      ),
    );
  }
}