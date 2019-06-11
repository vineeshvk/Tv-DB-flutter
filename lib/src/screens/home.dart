import 'package:flutter/material.dart';
import 'package:tv_db/src/bloc/tv_list.dart';
import 'package:tv_db/src/components/bottom_tab.dart';
import 'package:tv_db/src/screens/tv_list.dart';

class HomeScreen extends StatelessWidget {
  final ctrl = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: ctrl,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          TvListScreen(tvListBloc: popularBloc, header: "Trending"),
          TvListScreen(tvListBloc: topRatedBloc, header: "Top Rated"),
          TvListScreen(tvListBloc: todayBloc, header: "Currently On Air")
        ],
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomTabBar(
        selectedItemColor: Colors.red.withOpacity(.35),
        unSelectedItemColor: Colors.grey[300],
        items: [
          'assets/svg/trending.svg',
          'assets/svg/rating.svg',
          'assets/svg/today.svg'
        ],
        onChanged: (val) {
          ctrl.animateToPage(
            val,
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
          );
        },
      ),
    );
  }
}
