import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rok_scholar/database/database_helper.dart';
import 'package:rok_scholar/database/question.dart';
import 'package:share_plus/share_plus.dart';

Container createQuestion(BuildContext context, Question question) {
  return Container(
    width: MediaQuery.of(context).size.width,
    margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
    decoration: BoxDecoration(
      color: Theme.of(context)
          .colorScheme
          .secondary, // Set your desired background color
      borderRadius: BorderRadius.circular(15.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8.h),
          child: Text(
            question.question,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16.sp, color: Theme.of(context).colorScheme.surface),
          ),
        ),
        devider(context),
        Padding(
          padding: EdgeInsets.all(8.h),
          child: Text(
            'Answer: ${question.answer}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.surface),
          ),
        ),
        devider(context),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BookmarkWidget(
              question: question,
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/icons/share.svg',
                height: 24.h,
                width: 24.w,
                color: Theme.of(context).colorScheme.surface,
              ),
              onPressed: () {
                Share.share(
                    'RoK Scholar:\n\n${question.question}\n\nAnswer: ${question.answer}');
              },
            ),
          ],
        ),
      ],
    ),
  );
}

Container devider(BuildContext context) {
  return Container(
    height: 1.h,
    margin: EdgeInsets.symmetric(horizontal: 8.w),
    decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiary),
  );
}

class BookmarkWidget extends StatefulWidget {
  final Question question;

  BookmarkWidget({Key? key, required this.question}) : super(key: key);

  @override
  _BookmarkWidgetState createState() => _BookmarkWidgetState();
}

class _BookmarkWidgetState extends State<BookmarkWidget> {
  late bool isBookmarked; // Declare isBookmarked

  @override
  void initState() {
    super.initState();
    isBookmarked = widget.question.bookmarked; // Initialize in initState
  }

  @override
  Widget build(BuildContext context) {
    isBookmarked = widget.question.bookmarked;
    return IconButton(
      icon: isBookmarked
          ? SvgPicture.asset(
              'assets/icons/calendar-check.svg', // Icon when bookmarked
              height: 24.h,
              width: 24.w,
              color: Theme.of(context).colorScheme.surface,
            )
          : SvgPicture.asset(
              'assets/icons/calendar-plus.svg', // Icon when not bookmarked
              height: 24.h,
              width: 24.w,
              color: Theme.of(context).colorScheme.surface,
            ),
      onPressed: () async {
        setState(() {
          isBookmarked = !isBookmarked; // Toggle bookmark state
          widget.question.bookmarked = isBookmarked;
        });
        // Additional actions when button is pressed, if any
        await DatabaseHelper().toggleBookmark(widget.question);
      },
    );
  }
}
