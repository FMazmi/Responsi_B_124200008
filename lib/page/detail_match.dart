import 'package:flutter/material.dart';

import '../model/detail_matches_model.dart';
import '../model/matches_model.dart';
import '../service/base_network.dart';

class MatchDetail extends StatefulWidget {
  final MatchesModel? match;
  const MatchDetail({Key? key, required this.match}) : super(key: key);

  @override
  State<MatchDetail> createState() => _MatchDetailState();
}

class _MatchDetailState extends State<MatchDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Match ID : ${widget.match?.id}",
          style: const TextStyle(fontSize: 16),
        ),
        // automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 155, 7, 46),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
          future: BaseNetwork.get("matches/${widget.match?.id}"),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingSection();
            } else if (snapshot.hasError) {
              debugPrint(snapshot.toString());
              return _buildErrorSection();
            } else if (snapshot.hasData) {
              DetailMatchesModel matchModel =
                  DetailMatchesModel.fromJson(snapshot.data);
              return _buildSuccessSection(matchModel);
            } else {
              return const ListTile(
                title: Text("Data tidak dapat ditemukan"),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildErrorSection() {
    return const Text("Error");
  }

  Widget _buildLoadingSection() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(DetailMatchesModel data) {
    HomeTeamDetail? home = data.homeTeam!;
    AwayTeamDetail? away = data.awayTeam!;
    Statistics? homeStats = home.statistics!;
    Statistics? awayStats = away.statistics!;
    int passAccHome = ((homeStats.passesCompleted!.toDouble() /
                homeStats.passes!.toDouble()) *
            100)
        .round();
    int passAccAway = ((awayStats.passesCompleted!.toDouble() /
                awayStats.passes!.toDouble()) *
            100)
        .round();

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _countryBuilder(home.name),
              Text(
                " ${home.goals} - ${away.goals} ",
                style: const TextStyle(fontSize: 20),
              ),
              _countryBuilder(away.name),
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 8)),
          Text("Stadium : ${data.venue}"),
          const Padding(padding: EdgeInsets.only(top: 8)),
          Text("Location : ${data.location}"),
          const Padding(padding: EdgeInsets.only(top: 8)),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(border: Border.all()),
            child: Column(
              children: [
                const Text("Statistics", style: TextStyle(fontSize: 24)),
                _statsBuilder("Ball Possession", homeStats.ballPossession,
                    awayStats.ballPossession),
                _statsBuilder(
                    "Shot", homeStats.attemptsOnGoal, awayStats.attemptsOnGoal),
                _statsBuilder("Shot on Goal", homeStats.kicksOnTarget,
                    awayStats.kicksOnTarget),
                _statsBuilder("Corners", homeStats.corners, awayStats.corners),
                _statsBuilder(
                    "Offside", homeStats.offsides, awayStats.offsides),
                _statsBuilder(
                    "Fouls", homeStats.foulsCommited, awayStats.foulsCommited),
                _statsBuilder("Pass Accuracy", "$passAccHome%", "$passAccAway%")
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 8)),
          const Text("Referees :", style: TextStyle(fontSize: 20)),
          const Padding(padding: EdgeInsets.only(top: 8)),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: data.officials!.map((ofc) {
                  return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 160,
                      width: 130,
                      decoration: BoxDecoration(border: Border.all()),
                      child: Column(
                        children: [
                          const Image(
                            image: NetworkImage(
                                'https://static.vecteezy.com/system/resources/previews/000/570/948/original/vector-whistle-icon.jpg'),
                            height: 80,
                            fit: BoxFit.fitWidth,
                          ),
                          Text(
                            "${ofc.name}",
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "${ofc.role}",
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ));
                }).toList(),
              ))
        ],
      ),
    );
  }

  Widget _countryBuilder(String? name) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade400, spreadRadius: 1, blurRadius: 8)
            ],
          ),
          child: Image.network(
            "https://countryflagsapi.com/png/${(name == "Korea Republic" ? 'kor' : name)}",
            width: MediaQuery.of(context).size.width / 3,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
        Text(
          "$name",
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _statsBuilder(String title, dynamic stat1, dynamic stat2) {
    return Column(children: [
      const Padding(padding: EdgeInsets.only(top: 8)),
      Text(title),
      const Padding(padding: EdgeInsets.only(top: 8)),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "$stat1",
          ),
          const Text("-"),
          Text(
            "$stat2",
          )
        ],
      ),
    ]);
  }
}
