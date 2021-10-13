import 'package:flutter/material.dart';

class EmptyPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 64, right: 64),
            child: Image.asset("assets/illustrations/empty.png"),
          ),
          SizedBox(height: 32),
          Text(
            'It\'s pretty empty here :/',
            style: TextStyle(color: Colors.grey[500], fontSize: 24),
          ),
        ],
      ),
    );
  }
}