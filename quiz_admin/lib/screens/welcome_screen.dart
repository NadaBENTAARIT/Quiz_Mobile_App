import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quiz_app/screens/manage_quiz/indexmanage.dart';
import 'package:quiz_app/screens/start_quiz/indexstart.dart';
import 'package:quiz_app/screens/create_quiz/create_quiz.dart';
import '../constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);
  static const routeName = '/Edit_screen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreen();
}

class _WelcomeScreen extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 233, 239, 241),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 32.0),
              Text(
                'Welcome To Quiz App',
                style: TextStyle(
                  color: Color.fromARGB(255, 32, 81, 186),
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
                
              ),
              Text(
                'Area Admin',
                style: TextStyle(
                  color: Color.fromARGB(255, 32, 81, 186),
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
                
              ),
              SizedBox(height: 64.0),
              Image(
                image: AssetImage('assets/images/welcome.png'),
                height: 200,
                width: 200,
              ),
              SizedBox(height: 64.0),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateScreen()),
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Create Quiz'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent,
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => IndexManageScreen()),
                  );
                },
                icon: Icon(Icons.edit),
                label: Text('Manage Quiz'),
                //modifier quiz ou update quiz
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent,
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IndexStartScreen()),
                  );
                },
                icon: Icon(Icons.play_arrow),
                label: Text('Start Quiz'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent,
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
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
