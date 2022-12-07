import 'package:flutter/material.dart';
import 'package:responsi_124200008/page/detail_match.dart';

import '../model/matches_model.dart';
import '../service/base_network.dart';

class ListMatch extends StatefulWidget {
  const ListMatch({Key? key}) : super(key: key);
  @override
  _ListMatchState createState() => _ListMatchState();
}

class _ListMatchState extends State<ListMatch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildMatchesBody(),
    );
  }

  Widget _buildMatchesBody() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Piala Dunia Qatar 2022",
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 155, 7, 46),
        leading: Image.network(
          'https://1.bp.blogspot.com/-GyXN18qfp3Y/XW9G9eaeJUI/AAAAAAAABA0/Ecx-QFmtsXcdu6jBjXxZcE9ftmFT1Z-EQCLcBGAs/s320/Logo%2Bpiala%2Bdunia%2B2022%2Bqatar.png',
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: BaseNetwork.getList('matches'),
        builder: (
          BuildContext context,
          AsyncSnapshot<dynamic> snapshot,
        ) {
          if (snapshot.hasError) {
            print(snapshot);
            return _buildErrorSection();
          }
          if (snapshot.hasData) {
            MatchesDataModel matchesModel =
                MatchesDataModel.fromJson(snapshot.data);
            return _buildSuccessSection(matchesModel);
          }
          return _buildLoadingSection();
        },
      ),
    );
  }

  Widget _buildErrorSection() {
    return Text("Error");
  }

  // Widget _buildEmptySection() {
  //   return Text("Empty");
  // }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildSuccessSection(MatchesDataModel data) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: 48,
          itemBuilder: (BuildContext context, int index) {
            final MatchesModel? matches = data.matches?[index];
            return InkWell(
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: ((context) {
                return MatchDetail(match: matches);
              }))),
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade400,
                                  spreadRadius: 1,
                                  blurRadius: 8)
                            ],
                          ),
                          child: Image.network(
                            "https://countryflagsapi.com/png/${matches?.homeTeam?.name}",
                            width: MediaQuery.of(context).size.width / 3,
                          ),
                        ),
                        Text(
                          "${matches!.homeTeam?.name}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    Text(
                      " ${matches.homeTeam?.goals} - ${matches.awayTeam?.goals} ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade400,
                                  spreadRadius: 1,
                                  blurRadius: 8)
                            ],
                          ),
                          child: Image.network(
                            "https://countryflagsapi.com/png/${matches.awayTeam?.name}",
                            width: MediaQuery.of(context).size.width / 3,
                          ),
                        ),
                        Text(
                          "${matches.awayTeam?.name}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
