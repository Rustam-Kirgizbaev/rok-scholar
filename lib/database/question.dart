import 'dart:math';

import 'package:rok_scholar/database/database_helper.dart';

List<String> countryNames = [
  'Antarctica',
  'Argentina',
  'Austria',
  'Barbados',
  'Belgium',
  'Brazil',
  'Chile',
  'China',
  'Cyprus',
  'Denmark',
  'Ecuador',
  'Egypt',
  'Finland',
  'France',
  'Georgia',
  'Germany',
  'Greece',
  'Greenland',
  'Guatemala',
  'Iceland',
  'India',
  'Indonesia',
  'Italy',
  'Jamaica',
  'Japan',
  'Mali',
  'Mexico',
  'Nauru',
  'Netherlands',
  'Norway',
  'Panama',
  'Portugal',
  'Qatar',
  'Spain',
  'Tunisia',
  'Turkey',
  'Uruguay',
  'USA',
  'USSR',
];

List<String> riseOfKingdomsCommanders = [
  'Aethelflaed',
  'Alexander the Great',
  'Artemisia I',
  'Attila',
  'Boudica',
  'Cao Cao',
  'Charlemagne',
  'Charles Martel',
  'Cleopatra VII',
  'Constantine I',
  'El Cid',
  'Frederick I',
  'Julius Caesar',
  'Genghis Khan',
  'Hannibal Barca',
  'Joan of Arc',
  'Karl Martell',
  'Leonidas I',
  'Lohar',
  'Mehmed II',
  'Minamoto no Yoshitsune',
  'Osman I',
  'Pelagius',
  'Richard I',
  'Saladin',
  'Scipio Africanus',
  'Sun Tzu',
  'Tomyris',
  'William Wallace',
  'Yi Seong-Gye',
  'Yi Sun-sin',
  'Zenobia'
];

class QuestionUtils {
  static int? findNumberInAnswer(String input) {
    // Regular expression for finding numbers
    final RegExp numRegExp = RegExp(r'\d+');

    // Find the first match
    final Match? match = numRegExp.firstMatch(input);

    if (match != null) {
      // Convert the matched string to an integer and return
      return int.parse(match.group(0)!);
    }

    // Return null if no number is found
    return null;
  }

  static String? findStringInAnswer(String input, List<String> strs) {
    for (int i = 0; i < strs.length; i++) {
      if (input.contains(strs[i])) {
        return strs[i];
      }
    }

    return null;
  }

  static Future<PracticeQuestion> getPracticeQuestion() async {
    List<Question> questions = await DatabaseHelper().getRandom4Question();
    PracticeQuestion question = PracticeQuestion.fromQuestion(questions[0]);

    if (question.answers.isNotEmpty) {
      return question;
    } else {
      List<String> answers = questions.map((q) {
        return q.answer;
      }).toList();
      answers.shuffle(Random());

      return PracticeQuestion(
          question: questions[0].question,
          answer: questions[0].answer,
          answers: answers);
    }
  }
}

class PracticeQuestion {
  String question;
  String answer;
  List<String> answers;

  PracticeQuestion(
      {required this.question, required this.answer, required this.answers});

  factory PracticeQuestion.fromQuestion(Question question) {
    List<String> answers = [];

    int? numberInAnswer = QuestionUtils.findNumberInAnswer(question.answer);
    if (numberInAnswer != null) {
      Random random = Random();
      List<int> numbers = [1, 2, 3];
      int i = 0;
      while (answers.length < 3) {
        bool add = random.nextBool();
        if (add) {
          answers.add(question.answer.replaceFirst(numberInAnswer.toString(),
              (numberInAnswer + numbers[i]).toString()));
        } else {
          if (numberInAnswer - numbers[i] > 0) {
            answers.add(question.answer.replaceFirst(numberInAnswer.toString(),
                (numberInAnswer - numbers[i]).toString()));
          } else {
            answers.add(question.answer.replaceFirst(numberInAnswer.toString(),
                (numberInAnswer + numbers[i]).toString()));
          }
        }
        i++;
      }
      answers.add(question.answer);
      answers.shuffle(Random());
      return PracticeQuestion(
          question: question.question,
          answer: question.answer,
          answers: answers);
    }

    String? countryInAnswer =
        QuestionUtils.findStringInAnswer(question.answer, countryNames);
    if (countryInAnswer != null) {
      countryNames.shuffle(Random());

      int i = 0;
      while (answers.length < 3) {
        if (countryInAnswer != countryNames[i]) {
          answers.add(
              question.answer.replaceFirst(countryInAnswer, countryNames[i]));
        }
        i++;
      }
      answers.add(question.answer);
      answers.shuffle(Random());
      return PracticeQuestion(
          question: question.question,
          answer: question.answer,
          answers: answers);
    }

    String? commander = QuestionUtils.findStringInAnswer(
        question.answer, riseOfKingdomsCommanders);
    if (commander != null) {
      riseOfKingdomsCommanders.shuffle(Random());

      int i = 0;
      while (answers.length < 3) {
        if (countryInAnswer != riseOfKingdomsCommanders[i]) {
          answers.add(question.answer
              .replaceFirst(commander, riseOfKingdomsCommanders[i]));
        }
        i++;
      }
      answers.add(question.answer);
      answers.shuffle(Random());
      return PracticeQuestion(
          question: question.question,
          answer: question.answer,
          answers: answers);
    }

    return PracticeQuestion(
        question: question.question, answer: question.answer, answers: []);
  }
}

class Question {
  int id;
  String question;
  String answer;
  bool bookmarked;

  Question(
      {required this.id,
      required this.question,
      required this.answer,
      required this.bookmarked});

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
        id: map['id'] as int,
        question: map['question'],
        answer: map['answer'],
        bookmarked: (map['bookmarked'] as int) == 1);
  }
}
