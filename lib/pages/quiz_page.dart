import 'package:flutter/material.dart';

import '../utils/question.dart';
import '../utils/quiz.dart';
import '../UI/answer_button.dart';
import '../UI/question_text.dart';
import '../UI/correct_wrong_overlay.dart';
import 'score_page.dart';

class QuizPage extends StatefulWidget {
  @override
  State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {

  Question currentQuestion;
  Quiz quiz = new Quiz([
    new Question("Elon Musk is human", false),
    new Question("Pizza is healthy", false),
    new Question("Flutter is awesome", true)
  ]);

  bool isCorrect;
  bool overlayShouldBeVisible = false;

  @override
  void initState() {
    super.initState();
    currentQuestion = quiz.nextQuestion;
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column(
          children: <Widget>[
            new AnswerButton(true, () => handleAnswer(true) ),
            new QuestionText(currentQuestion.question, quiz.questionNumber),
            new AnswerButton(false, () => handleAnswer(false) )
          ],
        ),
        overlayShouldBeVisible ? new CorrentWrongOverlay(isCorrect, () {
          currentQuestion = quiz.nextQuestion;
          if (currentQuestion==null) {
            Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => new ScorePage(quiz.score, quiz.length)), (Route route) => route == null);
            return;
          }
          this.setState(() {
            overlayShouldBeVisible = false; 
          }); 
          }) : new Container()
      ],
    );
  }

  void handleAnswer(bool answer) {
    isCorrect = currentQuestion.answer == answer;
    quiz.answer(isCorrect);
    this.setState(() {
      overlayShouldBeVisible = true;
    });
  }
}
