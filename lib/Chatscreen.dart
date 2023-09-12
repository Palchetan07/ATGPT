import 'dart:async';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

import 'package:atgptbot/ChatMessage.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _message = [];

  late OpenAI openAI;

  StreamSubscription? _subscription;

  @override
  void initState() {
    openAI = OpenAI.instance.build(
        baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 18)),
        isLogger: true);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  //api key :

  void _sendMessage() {
    ChatMessage message = ChatMessage(text: _controller.text, sender: 'user');
    setState(() {
      _message.insert(0, message);
    });

    _controller.clear();

    final request = CompleteText(
      maxTokens: 200,
      prompt: message.text,
      model: kTextDavinci2,
    );
    _subscription = openAI
        .build(token: 'apikey')
        .onCompletionStream(request: request)
        .listen((response) {
      ChatMessage botMessage = ChatMessage(
        text: response!.choices[0].text,
        sender: 'bot',
      );

      setState(() {
        _message.insert(0, botMessage);

      });
    });
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            onSubmitted: (value) => _sendMessage(),
            decoration:
                const InputDecoration.collapsed(hintText: 'Send a message'),
          ),
        )),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            return _sendMessage();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('AT GPT BOT'),
      ),
      body: SafeArea(
        child: Column(children: [
          Flexible(
              child: ListView.builder(
                  reverse: true,
                  itemCount: _message.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _message[index],
                    );
                  })),
          Container(
              decoration: const BoxDecoration(
                  shape: BoxShape.rectangle, color: Colors.white),
              child: _buildTextComposer()),
        ]),
      ),
    );
  }
}
