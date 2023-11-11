import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AIChatScreen extends StatefulWidget {
  @override
  AIChatScreenState createState() => AIChatScreenState();
}

class AIChatScreenState extends State<AIChatScreen> {
  TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Message(
                  text: messages[index]['text']!,
                  sender: messages[index]['sender']!,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage('You', _controller.text);
                    _controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void _sendMessage(String sender, String message) async {
    setState(() {
      messages.add({'text': '$sender: $message', 'sender': sender});
    });

    var response = await http.post(
      Uri.parse('http://localhost:5000/get'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'msg': message}),
    );
    var data = json.decode(response.body);

    setState(() {
      messages.add({'text': 'Bot: ${data["response"]}', 'sender': 'Bot'});
    });
  }
}

class Message extends StatelessWidget {
  final String text;
  final String sender;

  Message({required this.text, required this.sender});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Align(
        alignment:
            sender == 'You' ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: sender == 'You' ? Colors.blue : Colors.green,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            text,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
