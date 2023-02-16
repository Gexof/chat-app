import 'package:chat_app/helper/constants.dart';
import 'package:flutter/material.dart';

import '../widgets/chat_buble.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});
  static String id = 'ChatScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        centerTitle: true,
        title: Image.asset(logoPath, height: 50),
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return ChatBuble();
      }),
    );
  }
}
