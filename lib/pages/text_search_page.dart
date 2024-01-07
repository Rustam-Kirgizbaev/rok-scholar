import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rok_scholar/services/ad.service.dart';
import 'package:rok_scholar/widgets/question.dart';
import 'package:rok_scholar/widgets/search_bar.dart';

import '../database/database_helper.dart';
import '../database/question.dart';

class TextSearchPage extends StatefulWidget {
  @override
  _TextSearchPageState createState() => _TextSearchPageState();
}

class _TextSearchPageState extends State<TextSearchPage> {
  String _searchTerm = '';
  final TextEditingController _controller = TextEditingController();
  List<Question> _filteredQuestions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    // Fetch all questions initially or handle this according to your app logic
    List<Question> allQuestions =
        await DatabaseHelper().getQuestions(_searchTerm);
    setState(() {
      _filteredQuestions = allQuestions;
    });
  }

  void _updateSearchResults(String searchTerm) {
    setState(() {
      _searchTerm = searchTerm;
      // Add your logic to filter questions based on the search term
      // For example:
      // _filteredQuestions = allQuestions.where((question) =>
      //                     question.questionText.contains(searchTerm)).toList();
    });
    _loadQuestions();
  }

  void _clearSearchTerm() {
    _controller.clear();
    _updateSearchResults('');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.all(16.h),
            child: SearchBarWidget(onTextChanged: _updateSearchResults)),
        AdService(),
        _filteredQuestions.isEmpty
            ? Center(
                child: Text(
                  "Start to explore by typing question",
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: Theme.of(context).colorScheme.surface),
                  textAlign: TextAlign.center,
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
