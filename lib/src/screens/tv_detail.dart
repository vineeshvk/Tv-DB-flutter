import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tv_db/src/bloc/tv_seasons.dart';
import 'package:tv_db/src/constants/api.dart';
import 'package:tv_db/src/models/tv_episodes.dart';
import 'package:tv_db/src/models/tv_list.dart';
import 'package:tv_db/src/models/tv_seasons.dart';

class TvDetailScreen extends StatefulWidget {
  final TvModel show;
  TvDetailScreen({@required this.show});

  @override
  _TvDetailScreenState createState() => _TvDetailScreenState();
}

class _TvDetailScreenState extends State<TvDetailScreen> {
  int activeSeason = -1;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    seasonsBloc.getSeason(widget.show.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
      appBar: appBarComponent(),
      backgroundColor: Colors.white,
    );
  }

  Widget appBarComponent() {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget body() {
    final titleTextStyle = TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
    return Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Container(height: 20),
          mainImageComponent(context),
          Container(height: 20),
          nameTextComponent(),
          genreListComponent(),
          progressBarComponent(),
          Container(height: 25),
          Text("OverView", style: titleTextStyle),
          Container(height: 15),
          Text(widget.show.overview),
          Container(height: 35),
          Text("Seasons", style: titleTextStyle),
          Container(height: 20),
          seasonStreamComponent()
        ],
      ),
    );
  }

  Widget mainImageComponent(context) {
    final size = MediaQuery.of(context).size;
    final height = size.height / 1.55;
    final width = size.width / 1.28;
    final heroTag = widget.show.posterPath ?? "${Random().nextInt(999999)}";

    return Hero(
      tag: heroTag,
      child: Center(
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            image: DecorationImage(
              image: NetworkImage("$image_url${widget.show.posterPath}"),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                offset: Offset(0, 10),
                color: Colors.black.withOpacity(.35),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget nameTextComponent() {
    return Text(
      widget.show.name,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
    );
  }

  Widget genreListComponent() {
    final genres = widget.show.genres;
    return Container(
      height: 31,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: genres.length,
        itemBuilder: (context, index) => genreItemComponent(genres[index]),
      ),
    );
  }

  Widget genreItemComponent(String genre) {
    return Container(
      height: 10,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        "$genre",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget progressBarComponent() {
    double vote = (widget.show.vote * 10);

    return Container(
      padding: EdgeInsets.all(9),
      child: Column(
        children: <Widget>[
          Text(
            "${vote.toStringAsPrecision(2)}% vote",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          LinearProgressIndicator(
            backgroundColor: Colors.grey[400],
            value: widget.show.vote / 10,
            valueColor: AlwaysStoppedAnimation(Colors.red[300]),
          ),
        ],
      ),
    );
  }

  Widget seasonStreamComponent() {
    return StreamBuilder(
      stream: seasonsBloc.seasonSubject,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TvSeasonsModel seasons = snapshot.data;
          return seasonsListComponent(seasons.seasons);
        }
        if (snapshot.hasError) Center(child: Text(snapshot.error.toString()));

        return Center(child: CupertinoActivityIndicator());
      },
    );
  }

  Widget seasonsListComponent(List<SeasonModel> seasons) {
    return ListView.separated(
      controller: scrollController,
      shrinkWrap: true,
      itemCount: seasons.length,
      physics: BouncingScrollPhysics(),
      separatorBuilder: (ctx, i) => Container(height: 20),
      itemBuilder: (context, index) => seasonItemComponent(seasons[index]),
    );
  }

  Widget seasonItemComponent(SeasonModel season) {
    bool active = activeSeason == season.seasonNo;
    return AnimatedContainer(
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 1000),
      padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
      margin: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: seasonNameComponent(season),
          ),
          if (active && season.episodes != null)
            episodeListComponent(season.episodes.episodes)
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: Colors.red.withOpacity(.1),
            width: active ? 0 : 1,
          ),
          boxShadow: [
            if (active)
              BoxShadow(
                blurRadius: 20,
                color: Colors.red.withOpacity(.2),
                offset: Offset(0, 6),
              )
          ]),
    );
  }

  List<Widget> seasonNameComponent(SeasonModel season) {
    final active = activeSeason == season.seasonNo;
    return [
      Text(
        season.name,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      IconButton(
        color: Colors.red.withOpacity(.8),
        icon: Icon(active ? Icons.arrow_drop_up : Icons.arrow_drop_down_circle),
        onPressed: () {
          setState(() {
            activeSeason = active ? -1 : season.seasonNo;
          });
        },
      ),
    ];
  }

  Widget episodeListComponent(List<EpisodeModel> episodes) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: episodes?.length,
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.only(top: 15, bottom: 10),
      separatorBuilder: (ctx, i) => Divider(height: 20),
      itemBuilder: (context, index) => episodeItemComponent(episodes[index]),
    );
  }

  Widget episodeItemComponent(EpisodeModel episode) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Text(
        "${episode.episodeNo} ${episode.name}",
        style: TextStyle(color: Color(0xFF636363), fontSize: 16),
      ),
    );
  }
}
