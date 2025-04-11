import 'package:flutter/material.dart';
import 'package:gemini_ai_test/view/chat.dart';
import 'package:gemini_ai_test/view_models/chat_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) =>
                ChatViewModel("AIzaSyD2hXuUr4CvLwaZGsfDjou38SrUSJn2fPs")),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}
