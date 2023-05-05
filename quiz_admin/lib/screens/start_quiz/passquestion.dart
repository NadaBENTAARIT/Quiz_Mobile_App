import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/start_quiz/ScorePage.dart';
import 'package:quiz_app/screens/start_quiz/beginstart.dart';

class PassQuestion extends StatefulWidget {
  final int quiz_code;

  PassQuestion(this.quiz_code, {Key? key}) : super(key: key);

  @override
  _PassQuestionState createState() => _PassQuestionState();
}

class _PassQuestionState extends State<PassQuestion> {
  final CollectionReference quizzesCollection =
      FirebaseFirestore.instance.collection('quizzes');
  int currentQuestionIndex = 0;
  bool quizFinished = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
                backgroundColor: Color.fromARGB(255, 233, 239, 241),

      appBar: AppBar(
        title: Text('Pass next question'),
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
              return Text('Une erreur est survenue : ${snapshot.error}');
            }
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final doc = snapshot.data!;
            final List<dynamic> questions = doc['questions'];

            if (currentQuestionIndex >= questions.length) {
              quizFinished = true;
            }

            if (quizFinished) {
              // Mettre à jour l'attribut question_selected de la dernière question
              questions[questions.length - 1]['question_selected'] = false;

              // Mettre à jour l'attribut quiz_finished du quiz
              doc.reference.update({
                'quiz_finished': true,
              });

              // Mettre à jour la question dans la base de données
              final quizRef = quizzesCollection.doc(doc.id);
              quizRef.update({
                'questions': questions,
              });

              // Rediriger vers la page de score
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ScorePageScreen(widget.quiz_code),
                ),
              );

              return Container();
            }

            final Map<String, dynamic> currentQuestion =
                questions[currentQuestionIndex];

            if (currentQuestionIndex > 0) {
              // Mettre à jour l'attribut question_selected de la question précédente
              questions[currentQuestionIndex - 1]['question_selected'] = false;
            }

            // Mettre à jour l'attribut question_selected de la question courante
            currentQuestion['question_selected'] = true;

            // Mettre à jour la question dans la base de données
            final quizRef = quizzesCollection.doc(doc.id);
            quizRef.update({
              'questions': questions,
            });

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 16),  
              Image(
                  image: AssetImage('assets/images/question1.png'),
                  height: 200,
                  width: 200,
                ),
                SizedBox(height: 16),  
                Text(
                  'Question N ${currentQuestionIndex + 1}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (currentQuestionIndex == questions.length - 1) {
                      // si c'est la dernière question
                      setState(() {
                        currentQuestion['question_selected'] = false;
                        // mettre à jour l'attribut question_selected de la dernière question
                      });
                      questions[questions.length - 1]['question_selected'] = false;
                      quizFinished = true;

                      await quizRef.update({
                        'quiz_finished': true,
                        'questions': questions,
                      });
                    } else {
                      // si ce n'est pas la dernière question
                      setState(() {
                        if (currentQuestionIndex + 1 < questions.length) {
                          // si la prochaine question existe
                          currentQuestion['question_selected'] = false;
                          // mettre à jour l'attribut question_selected de la question précédente
                          currentQuestionIndex++;
                          final Map<String, dynamic> nextQuestion =
                              questions[currentQuestionIndex];
                          nextQuestion['question_selected'] = true;
                          quizRef.update({
                            'questions': questions,
                          });
                        }
                      });
                    }
                  },
                  child: currentQuestionIndex < questions.length - 1
                      ? Text('Next')
                      : Text('End the quiz'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


 
