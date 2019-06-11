import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> items;
  final ValueChanged<int> onChanged;
  final Color selectedItemColor, unSelectedItemColor;

  CustomTabBar(
      {@required this.items,
      @required this.onChanged,
      this.selectedItemColor = Colors.red,
      this.unSelectedItemColor = Colors.grey});

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.red.withOpacity(.1),
                blurRadius: 10,
                offset: Offset(0, -5)),
          ],
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: tabItemsComponent().toList(),
        ));
  }

// MapEntry is used to take the index value of the list in order to show the selected item
  Iterable<InkWell> tabItemsComponent() {
    final tabItems = widget.items.asMap().map((i, item) {
      Color color = selectedIndex == i
          ? widget.selectedItemColor
          : widget.unSelectedItemColor;

      return MapEntry(
          i,
          InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  // color: Colors.green,
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 10),
                  child: SvgPicture.asset(item, color: color),
                ),
                Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(selectedIndex == i ? .3 : 0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Container(height: 5)
              ],
            ),
            onTap: () {
              if (selectedIndex != i)
                setState(() {
                  selectedIndex = i;
                });
              widget.onChanged(i);
            },
          ));
    });
    return tabItems.values;
  }
}
