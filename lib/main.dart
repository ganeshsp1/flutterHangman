import 'dart:math';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:hangman/customDrawer.dart';
import 'hangmanController.dart';

void main() => runApp(MyApp());

const List<String> alphabet = const [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z',
];

const List<String> animations = [
  "head",
  "body",
  "leftarm",
  "rightarm",
  "leftleg",
  "rightleg",
  "tail",
  "roar"
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Hangman',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Hangman'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _choosenLetters = new List<String>();
  String _currentAnimation = "idle";
  String _currentWord;
  List<String> _currentwordList = new List<String>();
  bool _gameOver = false;
  HangmanController _hangmanController;
  int _numberOfTries = 6;
  Random _random = new Random();
  int _score;
  int _wrongCount = -1;

  @override
  void initState() {
    _currentWord = nouns[_random.nextInt(nouns.length)];
    _currentwordList = _currentWord.toUpperCase().split("");
    _currentAnimation = "idle";
    _wrongCount = -1;
    _hangmanController = HangmanController();
    _score = _getScore();
        super.initState();
      }

      void _incrementCounter() {
        setState(() {
          _currentWord = nouns[_random.nextInt(nouns.length)];
          _choosenLetters = new List<String>();
          _currentwordList = _currentWord.toUpperCase().split("");
          _currentAnimation = "idle";
          _wrongCount = -1;
          _gameOver = false;
        });
      }

      bool _hasWon() {
        if (_currentwordList.isEmpty || _choosenLetters.isEmpty) {
          return false;
        }
        bool _hasWonBool = true;
        _currentwordList.forEach((eachletter) {
          if (!_choosenLetters.contains(eachletter.toUpperCase())) {
            _hasWonBool = false;
          }
        });
        if (_hasWonBool) {
          _gameOver = true;
        }
        if (_hasWonBool) {
          setState(() {
            // _currentAnimation = "won";
            _hangmanController.enqueueAnimation("won");
          });
        }
        return _hasWonBool;
      }

      int _getScore() {

      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text("Score$_score"),
                Spacer(),
                SizedBox(
                    height: MediaQuery.of(context).size.width * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: FlareActor(
                      "assets/animations/T-Rex.flr",
                      controller: _hangmanController,
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.fill,
                      animation: _currentAnimation,
                    )),
                SizedBox(
                  height: 10,
                ),
                Text(_hasWon() ? " You Won" : " "),
                Text((_wrongCount > _numberOfTries && !_gameOver)
                    ? "Game Over!"
                    : " "),
                // Text(_currentWord),
                // SizedBox(
                //   height: 10,
                // ),
                // Text(_choosenLetters.join(",")),
                SizedBox(
                  height: 50,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_currentWord.length, (int index) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Text(
                          ((_choosenLetters.contains(
                                      _currentWord[index].toUpperCase()) ||
                                  _wrongCount > _numberOfTries)
                              ? _currentWord[index].toUpperCase()
                              : " "),
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 30,
                          ),
                        ),
                      );
                    })),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    // alignment: WrapAlignment.center,
                    children: alphabet
                        .map((letter) => ButtonTheme(
                              minWidth: 45.0,
                              height: 50.0,
                              buttonColor: Colors.grey,
                              child: RaisedButton(
                                elevation: 2.0,
                                child: Text(
                                  letter,
                                  style: TextStyle(
                                    fontSize: 40,
                                  ),
                                ),
                                padding: EdgeInsets.all(1.0),
                                onPressed: (_choosenLetters
                                        .contains(letter.toUpperCase()))
                                    ? null
                                    : () {
                                        if (!_choosenLetters
                                                .contains(letter.toUpperCase()) &&
                                            !_gameOver) {
                                          setState(() {
                                            if (_wrongCount <= _numberOfTries) {
                                              _choosenLetters
                                                  .add(letter.toUpperCase());
                                              if (!_currentwordList
                                                  .contains(letter.toUpperCase())) {
                                                // _currentAnimation =
                                                //     animations[++_wrongCount];
                                                _hangmanController.enqueueAnimation(
                                                    animations[++_wrongCount]);
                                              }
                                            } else {
                                              _hangmanController.enqueueAnimation(
                                                  animations[_numberOfTries + 1]);
                                            }
                                          });
                                        }
                                      },
                                disabledColor:
                                    _currentwordList.contains(letter.toUpperCase())
                                        ? Colors.green
                                        : Colors.red,
                              ),
                            ))
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),      
          drawer: CustomDrawer(_currentWord),
        );
      }
}
