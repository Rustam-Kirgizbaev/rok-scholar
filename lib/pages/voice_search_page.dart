import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rok_scholar/services/ad.service.dart';
import 'package:rok_scholar/widgets/question.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../database/database_helper.dart';
import '../database/question.dart';

class Stt extends StatefulWidget {
  const Stt({Key? key}) : super(key: key);

  @override
  State<Stt> createState() => _SttState();
}

class _SttState extends State<Stt> {
  var text = "Click the button and start speaking";
  var isListening = false;
  List<Question> _filteredQuestions = [];

  SpeechToText speechToText = SpeechToText();

  @override
  void initState() {
    super.initState();
    checkMicrophoneAvailability();
  }

  @override
  void dispose() {
    // Cancel the speech listener or any other listeners
    speechToText.stop();
    super.dispose();
  }

  void _updateText(String newText) {
    if (mounted) {
      setState(() {
        text = newText;
      });
    }
  }

  void checkMicrophoneAvailability() async {
    bool available = await speechToText.initialize(
      onError: (errorNotification) => {_updateText(errorNotification.errorMsg)},
    );
    if (!available) {
      _updateText("The user has denied the use of speech recognition.");
    }
  }

  void _loadQuestions(String searchTerm) async {
    // Fetch all questions initially or handle this according to your app logic
    List<Question> allQuestions =
        await DatabaseHelper().getQuestions(searchTerm);
    setState(() {
      _filteredQuestions = allQuestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Your other widgets go here
        Expanded(
          child: Column(
            // Content of your page goes here
            // For example, this could be a ListView, text, images, etc.
            children: [
              AdService(),
              Padding(
                padding: EdgeInsets.all(24.h),
                child: Center(
                  child: Text(
                    text == "Click the button and start speaking"
                        ? text
                        : 'Your search query: $text',
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: Theme.of(context).colorScheme.surface),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              _filteredQuestions.isEmpty
                  ? Container()
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _filteredQuestions.length,
                        itemBuilder: (context, index) {
                          return createQuestion(
                              context, _filteredQuestions[index]);
                        },
                      ),
                    ),
            ],
          ),
        ),
        AvatarGlow(
          endRadius: 75.0,
          animate: isListening,
          duration: const Duration(milliseconds: 2000),
          glowColor: Theme.of(context).colorScheme.secondary,
          repeat: true,
          repeatPauseDuration: const Duration(milliseconds: 100),
          showTwoGlows: true,
          child: GestureDetector(
            onTap: () async {
              if (!isListening) {
                var available = speechToText.isAvailable;
                if (available) {
                  setState(() {
                    isListening = true;
                  });
                  speechToText.listen(
                      listenFor: const Duration(minutes: 15),
                      pauseFor: const Duration(seconds: 15),
                      listenMode: ListenMode.confirmation,
                      onResult: (result) {
                        _updateText(result.recognizedWords);
                        _loadQuestions(result.recognizedWords);
                      });
                }
              } else {
                setState(() {
                  isListening = false;
                });
                speechToText.stop();
              }
            },
            child: isListening
                ? SvgPicture.asset('assets/icons/microphone.svg',
                    width: 24.w,
                    height: 24.h,
                    color: Theme.of(context).colorScheme.surface)
                : SvgPicture.asset('assets/icons/mic-none.svg',
                    width: 24.w,
                    height: 24.h,
                    color: Theme.of(context).colorScheme.surface),
          ),
        ),
      ],
    );
  }
}
