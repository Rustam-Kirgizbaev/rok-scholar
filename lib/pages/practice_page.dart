import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rok_scholar/database/question.dart';
import 'package:rok_scholar/services/ad.service.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({Key? key}) : super(key: key);

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  late PracticeQuestion _question =
      PracticeQuestion(question: "", answer: "", answers: ["", "", "", ""]);
  late String _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _loadQuestion();
  }

  void _loadQuestion() async {
    PracticeQuestion question = await QuestionUtils.getPracticeQuestion();

    setState(() {
      _selectedAnswer = "";
      _question = question;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_question.answer.isNotEmpty) {
      return Column(
        children: [
          Center(
            child: Text(
              'Practice makes it perfect!\n(Harry Maguire)',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 18.sp),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            margin: EdgeInsets.all(16.h),
            padding: EdgeInsets.all(16.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Text(
              _question.question,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontSize: 18.sp),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 24.h,
          ),
          ..._question.answers.map((answer) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedAnswer = answer;
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.h, vertical: 8.h),
                padding: EdgeInsets.all(16.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: (_selectedAnswer == answer &&
                          answer != _question.answer)
                      ? Colors.red[200]
                      : _selectedAnswer.isNotEmpty && answer == _question.answer
                          ? Colors.green[200]
                          : Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Text(
                  answer,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 18.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }),
          Expanded(
              child: Container(
            child: AdService(),
          )),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context)
                      .colorScheme
                      .secondary, // Button background color
                  padding: EdgeInsets.all(16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r),
                  ),
                ),
                onPressed: _loadQuestion,
                child: Text(
                  'Next Question',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize: 18.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          )
        ],
      );
    } else {
      return CircularProgressIndicator();
    }
  }
}
