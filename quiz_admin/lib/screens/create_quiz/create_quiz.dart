import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class CreateScreen extends StatefulWidget {
  const CreateScreen({Key? key}) : super(key: key);
  static const routeName = '/CreateScreen';

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final CollectionReference quizzesCollection =
      FirebaseFirestore.instance.collection('quizzes');
  int _numQuestions = 0;
  Set<Widget> _questions = {};

  final TextEditingController _quizTitleController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();
  final TextEditingController _optionAController = TextEditingController();
  final TextEditingController _optionBController = TextEditingController();
  final TextEditingController _optionCController = TextEditingController();

  // Add text controllers as instance variables
  final List<TextEditingController> _questionControllers = [];
  final List<TextEditingController> _optionAControllers = [];
  final List<TextEditingController> _optionBControllers = [];
  final List<TextEditingController> _optionCControllers = [];
  final List<TextEditingController> _answerControllers = [];

  int _generateQuizCode() {
    int randomNumber = Random().nextInt(900000) + 100000;
    return randomNumber;
  }

  Future<void> addQuiz() async {
    try {
      final int quizCode = _generateQuizCode();

      final QuerySnapshot snapshot = await quizzesCollection.get();
      final int numQuizzes = snapshot.size;

      // Create a list of questions for the quiz
      List<Map<String, dynamic>> questions = _questions.map((question) {
        // Use the correct text controllers
        final int index = _questions.toList().indexOf(question);
        return {
          'question': _questionControllers[index].text,
          'option_a': _optionAControllers[index].text,
          'option_b': _optionBControllers[index].text,
          'option_c': _optionCControllers[index].text,
          'answer': _answerControllers[index].text,
          'question_selected': false,
        };
      }).toList();

      // Create a new document for the quiz in the "quizzes" collection
      await quizzesCollection.add({
        'index_quiz': numQuizzes +
            1, // Set the index_quiz field to the next available index
        'title': _quizTitleController.text,
        'quiz_code': quizCode,
        'quiz_start': false,
        'quiz_finished': false,
        'number_players': 0,
        'players': [],
        'questions': questions, // Add the list of questions to the document
      });

      // Clear the form fields and reset the state
      _quizTitleController.clear();
      _questionController.clear();
      _answerController.clear();
      _optionAController.clear();
      _optionBController.clear();
      _optionCController.clear();
      setState(() {
        _numQuestions = 0;
        _questions.clear();
        // Clear the text controllers
        _questionControllers.clear();
        _optionAControllers.clear();
        _optionBControllers.clear();
        _optionCControllers.clear();
        _answerControllers.clear();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Set<Widget> buildQuestionTextField(int questionNumber) {
    // Use the correct text controllers
    final int index = questionNumber - 1;
    _questionControllers.add(TextEditingController());
    _optionAControllers.add(TextEditingController());
    _optionBControllers.add(TextEditingController());
    _optionCControllers.add(TextEditingController());
    _answerControllers.add(TextEditingController());
    return {
      SizedBox(height: 20),
      Text(
        'Question $questionNumber',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 10),
      TextFormField(
        controller: _questionControllers[index],
        decoration: InputDecoration(
          labelText: 'Question',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.help_outline),
        ),
      ),
      SizedBox(height: 10),
      TextFormField(
        controller: _optionAControllers[index],
        decoration: InputDecoration(
          labelText: 'Option A',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.looks_one),
        ),
      ),
      SizedBox(height: 10),
      TextFormField(
        controller: _optionBControllers[index],
        decoration: InputDecoration(
          labelText: 'Option B',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.looks_two),
        ),
      ),
      SizedBox(height: 10),
      TextFormField(
        controller: _optionCControllers[index],
        decoration: InputDecoration(
          labelText: 'Option C',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.looks_3),
        ),
      ),
      SizedBox(height: 10),
      TextFormField(
        controller: _answerControllers[index],
        decoration: InputDecoration(
          labelText: 'Answer',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.check),
        ),
      ),
    };
  }
@override
Widget build(BuildContext context) {
  return Scaffold(

    appBar: AppBar(
      title: Text('Create Quiz'),
      backgroundColor: Colors.deepPurple, // modify app bar color
    ),
          backgroundColor: Color.fromARGB(255, 233, 239, 241),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiz Title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _quizTitleController,
              decoration: InputDecoration(
                labelText: 'Enter quiz title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Questions',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _numQuestions++;
                        _questions.add(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                                buildQuestionTextField(_numQuestions).toList(),
                          ),
                        );
                      });
                    },
                    icon: Icon(Icons.add, color: Colors.black),
                  ),
                ],
              ),
            ),
            ..._questions,
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: addQuiz,
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Create Quiz',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}