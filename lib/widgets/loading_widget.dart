import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String text;

  const LoadingWidget({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 15),
          Text(text),
        ],
      ),
    );
  }
}
