import 'package:flutter/material.dart';
import 'package:gemini_ai_test/view_models/chat_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:gemini_ai_test/model/message_model.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset('assets/Asset 2.png', height: 20),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatViewModel.messages.length,
              controller: _scrollController,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final message = chatViewModel.messages[index];
                return Align(
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    decoration: BoxDecoration(
                      color:
                          message.isUser ? Color(0xff2980b9) : Colors.grey[200],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: message.isUser
                            ? Radius.circular(20)
                            : Radius.circular(0),
                        bottomRight: message.isUser
                            ? Radius.circular(0)
                            : Radius.circular(20),
                      ),
                    ),
                    child: Text(
                      message.content,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(
                          color: message.isUser ? Colors.white : Colors.black,
                          fontSize: 14),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message',
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(0xff2980b9),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        chatViewModel.sendMessage(_controller.text);
                        _controller.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
