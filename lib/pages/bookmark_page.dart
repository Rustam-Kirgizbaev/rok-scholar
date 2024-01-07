import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rok_scholar/services/ad.service.dart';

import '../database/database_helper.dart';
import '../database/question.dart';
import '../widgets/question.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  bool _changeAvailable = false;
  List<Question> _filteredQuestions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    // Fetch all questions initially or handle this according to your app logic
    List<Question> allQuestions = await DatabaseHelper().getBookmarks();
    setState(() {
      _filteredQuestions = allQuestions;
      _changeAvailable = false;
    });
  }

  void _updateChange() {
    setState(() {
      _changeAvailable = true;
      // Add your logic to filter questions based on the search term
      // For example:
      // _filteredQuestions = allQuestions.where((question) =>
      //                     question.questionText.contains(searchTerm)).toList();
    });
    _loadQuestions();
  }

  @override
  Widget build(BuildContext context) {
    if (_changeAvailable) {
      _loadQuestions();
    }

    return Column(
      children: [
        AdService(),
        _filteredQuestions.isEmpty
            ? Padding(
                padding: EdgeInsets.all(16.h),
                child: Center(
                  child: Text(
                    "Here you can see your bookmarked question",
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: Theme.of(context).colorScheme.surface),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: _filteredQuestions.length,
                  itemBuilder: (context, index) {
                    return createQuestion(context, _filteredQuestions[index]);
                  },
                ),
              ),
      ],
    );
  }
}
