import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:neoflex/src/quiz/domain/models/quiz/quiz_dto.dart';
import '../../shared/widgets/neonchik_quiz.dart';
import '../data/local_quiz_source.dart';

class QuestionScreen extends StatefulWidget {
  final int questionIndex;

  const QuestionScreen({required this.questionIndex, Key? key}) : super(key: key);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> with TickerProviderStateMixin {
  QuizDTO? question;
  late AnimationController _controller;

  bool answered = false;
  bool isCorrect = false;

  @override
  void initState() {
    super.initState();
    _loadQuestion();

    _controller = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward(from: 0);
    });
  }

  Future<void> _loadQuestion() async {
    final questions = await LocalQuizSource().getQuestions();
    setState(() {
      question = questions[widget.questionIndex];
    });
  }

  Future<bool> _handleAnswer(String answer) async {
    if (answered || question == null) return false;

    final correct = question!.answer == answer;
    setState(() {
      answered = true;
      isCorrect = correct;
    });

    await Future<void>.delayed(const Duration(milliseconds: 500));


    return correct;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    if (question == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/begin.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenSize.height - kToolbarHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 500,
                      child: NeonchikQuiz(
                        title: question!.title,
                        answers: question!.answers,
                        onPressed: _handleAnswer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }}
