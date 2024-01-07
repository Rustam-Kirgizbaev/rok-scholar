import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(String) onTextChanged; // Define the callback function

  SearchBarWidget({required this.onTextChanged});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBarWidget> {
  TextEditingController _textEditingController = TextEditingController();
  bool _isSearchActive = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: Theme.of(context).colorScheme.secondary,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textEditingController,
              onChanged: (value) {
                setState(() {
                  _isSearchActive = value.isNotEmpty;
                });

                widget.onTextChanged(value);
              },
              decoration: InputDecoration(
                hintText: "Search",
                border: InputBorder.none,
              ),
            ),
          ),
          _isSearchActive
              ? GestureDetector(
                  onTap: () {
                    setState(() {
                      _textEditingController.clear();
                      _isSearchActive = false;
                    });
                    widget.onTextChanged("");
                  },
                  child: SvgPicture.asset(
                    'assets/icons/cross.svg',
                    color: Theme.of(context).colorScheme.surface,
                    width: 24.w,
                    height: 24.h,
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    // Perform search action here
                  },
                  child: SvgPicture.asset(
                    'assets/icons/search.svg',
                    color: Theme.of(context).colorScheme.surface,
                    width: 24.w,
                    height: 24.h,
                  ),
                ),
        ],
      ),
    );
  }
}
