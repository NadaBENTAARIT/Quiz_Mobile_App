import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:quiz_app/screens/begin_start.dart';


import '../constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  int? _quizCode;

  final CollectionReference quizzesCollection =
      FirebaseFirestore.instance.collection('quizzes');

  Future<bool> checkQuizCodeExists(int quizCode, String playerName) async {
    final result =
        await quizzesCollection.where('quiz_code', isEqualTo: quizCode).get();

    if (result.docs.isNotEmpty) {
      final quizDoc = result.docs.first;
      await quizDoc.reference.update({
        'number_players': FieldValue.increment(1),
        'players': FieldValue.arrayUnion([
          {'name': playerName, 'score': 0}
        ])
      });

      return true;
    } else {
      return false;
    }
  }@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromARGB(255, 233, 239, 241),
    body: Padding(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Welcome To Quiz App',
                    style: TextStyle(
                      color: Color.fromARGB(255, 32, 81, 186),
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Area Player',
                    style: TextStyle(
                      color: Color.fromARGB(255, 32, 81, 186),
                      fontSize: 10.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.0),
            Image(
              image: AssetImage('assets/images/welcome1.png'),
              height: 200,
              width: 200,
            ),
            SizedBox(height: 32.0),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Nom',
                icon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre nom';
                }
                return null;
              },
              onSaved: (value) {
                _name = value;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Code du quiz',
                icon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le code du quiz';
                } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'Le code de quiz ne doit contenir que des chiffres';
                }
                return null;
              },
              onSaved: (value) {
                _quizCode = int.tryParse(value!);
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 165, 65, 146),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  final quizExists =
                      await checkQuizCodeExists(_quizCode!, _name!);

                  if (quizExists) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BeginStartScreen(_name!, _quizCode!),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Le code de quiz n\'existe pas.'),
                      ),
                    );
                  }
                }
              },
              child: Text('Join quiz'),
            ),
          ],
        ),
      ),
    ),
  );
}
}