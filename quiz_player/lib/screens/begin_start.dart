import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BeginStartScreen extends StatefulWidget {
  final String name;
  final int quiz_code;

  BeginStartScreen(this.name, this.quiz_code, {Key? key}) : super(key: key);

  static const routeName = '/beginStartScreen';

  @override
  State<BeginStartScreen> createState() => _BeginStartScreenState();
}

class _BeginStartScreenState extends State<BeginStartScreen> {
  final CollectionReference quizzesCollection =
      FirebaseFirestore.instance.collection('quizzes');

  int score = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
        backgroundColor: Color.fromRGBO(232, 187, 214, 1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: quizzesCollection
            .where('quiz_code', isEqualTo: widget.quiz_code)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Une erreur est survenue'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final quizDoc = snapshot.data!.docs.first;

          final questionSelected = quizDoc['questions'].firstWhere(
              (question) => question['question_selected'] == true,
              orElse: () => null);

          if (questionSelected == null && quizDoc['quiz_finished'] == false) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (questionSelected == null && quizDoc['quiz_finished'] == true) {
            final playersList =
                List<Map<String, dynamic>>.from(quizDoc['players']);
            final user = playersList
                .firstWhere((player) => player['name'] == widget.name);
            ////classement
            return Center(
              child: Column(
                
             
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Image(
              image: AssetImage('assets/images/classement.png'),
              height: 200,
              width: 200,
            ),
             SizedBox(height: 16.0),
                  Icon(Icons.check_circle_outline,
                      size: 48.0, color: Colors.green),
                  SizedBox(height: 20),
                  Text('Your Score:',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold)),
                  Text('${user['score']}', style: TextStyle(fontSize: 48.0)),
                  SizedBox(height: 20),
                  Text('Your Classment:',
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold)),
                  Text('${_getRank(playersList, widget.name)}',
                      style: TextStyle(fontSize: 48.0)),
                ],
              ),
            );
          }

          final optionA = questionSelected['option_a'];
          final optionB = questionSelected['option_b'];
          final optionC = questionSelected['option_c'];
          final correctAnswer = questionSelected['answer'];

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               SizedBox(height: 16),  
              Image(
                  image: AssetImage('assets/images/yes.png'),
                  height: 200,
                  width: 200,
                ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  questionSelected['question'],
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(50, 20),
                    fixedSize: Size(200, 50),
                    //padding: EdgeInsets.symmetric(horizontal: 24.0),
                  ),
                  onPressed: () {
                    print("****************************");
                    print(optionA);
                    print(correctAnswer);
                    if (optionA == correctAnswer) {
                      _incrementScore();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: Colors.white, size: 28),
                      Text(
                        optionA,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(50, 20),
                    fixedSize: Size(200, 50),
                    //padding: EdgeInsets.symmetric(horizontal: 24.0),
                  ),
                  onPressed: () {
                    print("****************************");
                    print(optionB);
                    print(correctAnswer);
                    if (optionB == correctAnswer) {
                      _incrementScore();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: Colors.white, size: 28),
                      Text(
                        optionB,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueGrey,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(50, 20),
                    fixedSize: Size(200, 50),
                    //padding: EdgeInsets.symmetric(horizontal: 24.0),
                  ),
                  onPressed: () {
                    print("****************************");
                    print(optionC);
                    print(correctAnswer);
                    if (optionC == correctAnswer) {
                      _incrementScore();
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.check_circle_outline,
                          color: Colors.white, size: 28),
                      Text(
                        optionC,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Score: $score'),
            ],
          );
        },
      ),
    );
  }

  int _getRank(List<Map<String, dynamic>> players, String playerName) {
    players.sort((a, b) => b['score'].compareTo(a['score']));

    int rank = 1;
    for (int i = 0; i < players.length; i++) {
      final player = players[i];
      if (player['name'] == playerName) {
        return rank;
      }
      if (i + 1 < players.length && players[i + 1]['score'] < player['score']) {
        rank = i + 2;
      }
    }
    return rank;
  }

  Future<void> _incrementScore() async {
    setState(() {
      score += 10;
    });

    final result = await quizzesCollection
        .where('quiz_code', isEqualTo: widget.quiz_code)
        .get();

    if (result.docs.isNotEmpty) {
      final quizDoc = result.docs.first;
      final playersList = List<Map<String, dynamic>>.from(quizDoc['players']);

      final playerIndex = playersList.indexWhere(
        (player) => player['name'] == widget.name,
      );

      if (playerIndex != -1) {
        final player = playersList[playerIndex];
        playersList[playerIndex] = {
          'name': player['name'],
          'score': player['score'] + 10,
        };
      }

      await quizDoc.reference.update({
        'players': playersList,
      });
    }
  }
}
