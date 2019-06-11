import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tv_db/src/bloc/tv_list.dart';
import 'package:tv_db/src/bloc/tv_search.dart';
import 'package:tv_db/src/constants/api.dart';
import 'package:tv_db/src/models/tv_list.dart';
import 'package:tv_db/src/screens/tv_detail.dart';

class TvListScreen extends StatefulWidget {
  final TvListBloc tvListBloc;
  final String header;

  TvListScreen({@required this.tvListBloc, this.header = "Trending"});

  @override
  _TvListScreenState createState() => _TvListScreenState();
}

class _TvListScreenState extends State<TvListScreen> {
  int page, currentPageViewItem;
  String searchText;

  final inputController = TextEditingController();
  final pageController = PageController(viewportFraction: .8);

  @override
  void initState() {
    page = 1;
    currentPageViewItem = 0;
    searchText = "";

    widget.tvListBloc.getShows(page);
    super.initState();

    pageController.addListener(() {
      if (pageController.position.pixels ==
          pageController.position.maxScrollExtent) {
        widget.tvListBloc.getShows(page + 1);
        setState(() => page++);
      }
    });
  }

  Future<bool> _onWillPop() async {
    if (searchText == "") return true;

    setState(() {
      searchText = "";
    });
    inputController.clear();

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: 10),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              searchBarComponent(),
              if (searchText == "")
                ...mainListComponent()
              else
                searchStreamComponent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchBarComponent() {
    bool activeSearch = searchText == "";
    return Container(
      height: 45,
      padding: EdgeInsets.only(left: 15),
      margin: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        color: Color(0xFFECECEC),
        borderRadius: BorderRadius.circular(13),
      ),
      child: TextField(
        controller: inputController,
        textInputAction: TextInputAction.search,
        onChanged: (val) {
          setState(() {
            searchText = val.trim();
          });
          searchBloc.getSearch(val);
        },
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search any show",
            hintStyle: TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              color: activeSearch ? Colors.grey : Colors.red[300],
              icon: Icon(activeSearch ? Icons.search : Icons.cancel),
              onPressed: () {
                if (!activeSearch) {
                  setState(() {
                    searchText = "";
                  });
                  inputController.clear();
                }
              },
            )),
      ),
    );
  }

  Widget searchStreamComponent() {
    return Container(
      child: StreamBuilder(
        stream: searchBloc.searchSubject,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text(snapshot.error.toString()));

          if (!snapshot.hasData) return Container();

          TvListModel shows = snapshot.data;
          return searchListComponent(shows.shows);
        },
      ),
    );
  }

  Widget searchListComponent(List<TvModel> shows) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: shows.length,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.all(20),
      separatorBuilder: (ctx, i) => Divider(),
      itemBuilder: (context, index) => searchItemComponent(shows[index]),
    );
  }

  Widget searchItemComponent(TvModel show) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TvDetailScreen(show: show)));
      },
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        height: 80,
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Hero(
              tag: show.posterPath ?? "${Random().nextInt(999999)}",
              child: Image.network(
                "$image_low_url${show.posterPath}",
                height: 70,
                width: 50,
                fit: BoxFit.cover,
              ),
            ),
            Container(width: 20),
            Text(show.name)
          ],
        ),
      ),
    );
  }

  List<Widget> mainListComponent() {
    return [
      Container(height: 20),
      headerComponent(),
      Container(height: 15),
      streamBuilderComponent(),
    ];
  }

  Widget headerComponent() {
    return Container(
      padding: EdgeInsets.only(left: 20),
      child: Text(
        widget.header,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 30,
        ),
      ),
    );
  }

  Widget streamBuilderComponent() {
    return StreamBuilder(
      stream: widget.tvListBloc.tvSubject,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TvListModel showListModel = snapshot.data;
          return tvListComponent(showListModel.shows);
        }
        return Center(
          child: snapshot.hasError
              ? Text(snapshot.error.toString())
              : CupertinoActivityIndicator(),
        );
      },
    );
  }

  Widget tvListComponent(List<TvModel> shows) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height / 2 + 90,
      child: PageView.builder(
        itemCount: shows.length + 1,
        controller: pageController,
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return index == shows.length
              ? CupertinoActivityIndicator()
              : tvItemComponent(shows[index], index);
        },
        onPageChanged: (index) {
          if (currentPageViewItem != index) {
            setState(() {
              currentPageViewItem = index;
            });
          }
        },
      ),
    );
  }

  Widget tvItemComponent(TvModel show, int index) {
    bool active = currentPageViewItem == index;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: Container()),
        animatedComponent(active, show),
        Text(
          show.name,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget animatedComponent(bool active, TvModel show) {
    final size = MediaQuery.of(context).size;
    final pHeight = size.height / 2 + 35;
    final width = size.width;
    double height = active ? pHeight : pHeight - 80;

    return InkWell(
      child: Hero(
        tag: show.posterPath,
        child: AnimatedContainer(
          height: height,
          width: width,
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.only(right: width / 10, bottom: 27),
          foregroundDecoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage("$image_url${show.posterPath}"),
              ),
              boxShadow: [
                if (active)
                  BoxShadow(
                    color: Colors.black.withOpacity(.35),
                    blurRadius: 14,
                    offset: Offset(0, 10),
                  )
              ]),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TvDetailScreen(show: show)),
        );
      },
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
