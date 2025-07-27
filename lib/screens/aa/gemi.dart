// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _userInput = TextEditingController();
  static const apiKey = "AIzaSyDKqpjyBbXJ86EKKESHP2JYdkZhcxm-dzA";
  //final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
  final model =
      GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);
  final List<Message> _messages = [];
  Future<void> sendMessage() async {
    final message = _userInput.text;
    setState(() {
      _messages
          .add(Message(isUser: true, message: message, date: DateTime.now()));
    });
    final content = [Content.text(message)];
    final response = await model.generateContent(content);
    setState(() {
      _messages.add(Message(
          isUser: false, message: response.text ?? "", date: DateTime.now()));
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _userInput.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Chatbot',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            //color: const Color(0xfffaf8eb),
            color: const Color(0xffe0dfe2),
            image: DecorationImage(
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.04), BlendMode.dstATop),
              image: const AssetImage("assets/images/bot.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  child: ListView.builder(
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        return Messages(
                            isUser: message.isUser,
                            message: message.message,
                            date: DateFormat('HH:mm').format(message.date));
                      })),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 25,
                      child: TextFormField(
                        //style: const TextStyle(color: Colors.white),
                        controller: _userInput,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.blue),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.blue),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          label: const Text(
                            'Entrer votre message',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                        padding: const EdgeInsets.all(12),
                        //iconSize: 30,
                        style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.all(Colors.blue),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.white),
                            shape:
                                WidgetStateProperty.all(const CircleBorder())),
                        onPressed: () {
                          sendMessage();
                          _userInput.clear();
                        },
                        icon: const Icon(Icons.send))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;
  Message({required this.isUser, required this.message, required this.date});
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;
  const Messages(
      {super.key,
      required this.isUser,
      required this.message,
      required this.date});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 15)
          .copyWith(left: isUser ? 100 : 10, right: isUser ? 10 : 100),
      decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey.shade400,
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              bottomLeft: isUser ? const Radius.circular(10) : Radius.zero,
              topRight: const Radius.circular(10),
              bottomRight: isUser ? Radius.zero : const Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(
                fontSize: 16, color: isUser ? Colors.white : Colors.black),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            date,
            style: TextStyle(
              fontSize: 10,
              color: isUser ? Colors.white : Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
