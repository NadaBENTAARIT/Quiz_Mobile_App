import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {
  final int quiz_code;

  const UpdateScreen(this.quiz_code, {Key? key}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final CollectionReference quizzesCollection =
      FirebaseFirestore.instance.collection('quizzes');
  late List<Map<String, dynamic>> _questions = [];

  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  Future<void> _loadQuizData() async {
    try {
      final QuerySnapshot querySnapshot = await quizzesCollection
          .where("quiz_code", isEqualTo: widget.quiz_code)
          .get();
      final DocumentSnapshot quizSnapshot = querySnapshot.docs.first;
      print(quizSnapshot);

      final data = quizSnapshot.data();
      print(widget.quiz_code.toString());
      print(data);
      if (data != null && data is Map<String, dynamic>) {
        setState(() {
          _questions = List<Map<String, dynamic>>.from(
              data['questions'] as List<dynamic>);
        });
        print("Données chargées : $_questions");
        print("Format des données : ${_questions.runtimeType}");
      } else {
        setState(() {
          _errorMessage = 'No questions found.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateQuiz() async {
    try {
      final QuerySnapshot querySnapshot = await quizzesCollection
          .where("quiz_code", isEqualTo: widget.quiz_code)
          .get();
      final DocumentSnapshot quizSnapshot = querySnapshot.docs.first;
      final DocumentReference quizRef = quizzesCollection.doc(quizSnapshot.id);

      // Check if the document exists before attempting to update it
      //final DocumentSnapshot quizSnapshot = await quizRef.get();
      if (quizSnapshot.exists) {
        // Update the questions in the "quizzes" collection
        await quizRef.update({
          'questions': _questions, // Update the questions list
        });

        Navigator.of(context).pop();
      } else {
        setState(() {
          _errorMessage = 'Quiz not found.';
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _deleteQuiz() async {
    try {
      final QuerySnapshot querySnapshot = await quizzesCollection
          .where("quiz_code", isEqualTo: widget.quiz_code)
          .get();
      final DocumentSnapshot quizSnapshot = querySnapshot.docs.first;
      final DocumentReference quizRef = quizzesCollection.doc(quizSnapshot.id);

      // Check if the document exists before attempting to delete it
      if (quizSnapshot.exists) {
        await quizRef.delete();
        Navigator.of(context).pop();
      } else {
        setState(() {
          _errorMessage = 'Quiz not found.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Widget _buildQuestionTextField(Map<String, dynamic> question) {
    final TextEditingController _questionController =
        TextEditingController(text: question['question'] as String);
    final TextEditingController _optionAController =
        TextEditingController(text: question['option_a'] as String);
    final TextEditingController _optionBController =
        TextEditingController(text: question['option_b'] as String);
    final TextEditingController _optionCController =
        TextEditingController(text: question['option_c'] as String);
    final TextEditingController _answerController =
        TextEditingController(text: question['answer'] as String);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(
          'Question ${_questions.indexOf(question) + 1}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _questionController,
          decoration: InputDecoration(
            labelText: 'Question',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.help_outline),
          ),
          onChanged: (value) =>
              question['question'] = _questionController.text.trim(),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _optionAController,
          decoration: InputDecoration(
            labelText: 'Option A',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.looks_one),
          ),
          onChanged: (value) =>
              question['option_a'] = _optionAController.text.trim(),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _optionBController,
          decoration: InputDecoration(
            labelText: 'Option B',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.looks_two),
          ),
          onChanged: (value) =>
              question['option_b'] = _optionBController.text.trim(),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _optionCController,
          decoration: InputDecoration(
            labelText: 'Option C',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.looks_3),
          ),
          onChanged: (value) =>
              question['option_c'] = _optionCController.text.trim(),
        ),
        SizedBox(height: 10),
        TextFormField(
          controller: _answerController,
          decoration: InputDecoration(
            labelText: 'Answer',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.check),
          ),
          onChanged: (value) =>
              question['answer'] = _answerController.text.trim(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Quiz'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Questions',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _questions.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _buildQuestionTextField(_questions[index]);
                          },
                        ),
                         SizedBox(height: 20),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: _updateQuiz,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                              ),
                              child: Text('Update Quiz'),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: _deleteQuiz,
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                              ),
                              child: Text('Delete Quiz'),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
    );
  }
}
