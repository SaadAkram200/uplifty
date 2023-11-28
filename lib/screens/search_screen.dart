import 'package:flutter/material.dart';
import 'package:uplifty/utils/colors.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: CColors.background,
      body: const Center(
        child: Text(
          "Search Friends",
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
