import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/start_quiz/passquestion.dart';

class BeginStartScreen extends StatefulWidget {
  final String title;
  final int quiz_code;

  BeginStartScreen(this.title, this.quiz_code, {Key? key}) : super(key: key);

  static const routeName = '/beginStartScreen';

  @override
  State<BeginStartScreen> createState() => _BeginStartScreenState();
}

class _BeginStartScreenState extends State<BeginStartScreen> {
  final CollectionReference quizzesCollection =
      FirebaseFirestore.instance.collection('quizzes');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
                backgroundColor: Color.fromARGB(255, 233, 239, 241),

      appBar: AppBar(
        title: Text('Start quiz'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: quizzesCollection
              .where('quiz_code', isEqualTo: widget.quiz_code)
              .snapshots()
              .map((query) => query.docs.first),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                'Une erreur est survenue : ${snapshot.error}',
                style: TextStyle(
        backgroundColor: Colors.deepPurple,
                  fontSize: 18.0,
                ),
              );
            }

            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final doc = snapshot.data!;
            final numberPlayers = doc['number_players'] ?? 0;

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              SizedBox(height: 16),  
              Image(
                  image: AssetImage('assets/images/start.png'),
                  height: 200,
                  width: 200,
                ),
                SizedBox(height: 16),
                Text(
                  'Code of quiz : ${widget.quiz_code}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Number of players : $numberPlayers',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                SizedBox(height: 32),
                if (numberPlayers >=1)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 19, 4, 91),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () async {
                      final quizRef = quizzesCollection.doc(doc.id);

                      await quizRef.update({'quiz_start': true});

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PassQuestion(widget.quiz_code),
                        ),
                      );
                    },
                    child: Text(
                      'start quiz',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
