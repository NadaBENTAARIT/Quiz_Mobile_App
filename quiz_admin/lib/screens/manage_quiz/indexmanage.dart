import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/manage_quiz/update_quiz.dart';

class IndexManageScreen extends StatefulWidget {
  const IndexManageScreen({Key? key}) : super(key: key);
  static const routeName = '/Edit_screen';

  @override
  State<IndexManageScreen> createState() => _IndexManageScreenState();
}

class _IndexManageScreenState extends State<IndexManageScreen> {
  final CollectionReference quizzesCollection =
      FirebaseFirestore.instance.collection('quizzes');

  Future<List<DocumentSnapshot>> getQuizzes() async {
    try {
      QuerySnapshot snapshot = await quizzesCollection.get();
      return snapshot.docs;
    } catch (error) {
      print("Error getting quizzes: $error");
      return [];
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('List of quizses'),
        backgroundColor: Colors.deepPurple,
    ),
    body: FutureBuilder(
      future: getQuizzes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Erreur lors du chargement des quiz'),
          );
        }
        List<DocumentSnapshot> quizzes =
            snapshot.data as List<DocumentSnapshot>;
        return GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(10),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: List.generate(quizzes.length, (index) {
            String title = quizzes[index].get('title');
            int quiz_code = quizzes[index].get('quiz_code');
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateScreen(quiz_code),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: AssetImage('assets/images/title4.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.7),
                  ),
                  child: Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    ),
  );
}
}
