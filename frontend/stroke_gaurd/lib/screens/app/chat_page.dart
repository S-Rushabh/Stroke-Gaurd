import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isGenerating = false;
  late AnimationController _animationController;

  // Flask API URL
  final String _apiUrl = "http://10.110.3.172:5000/api/chat"; // Update for your local environment

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _sendPrompt(String prompt) async {
    if (prompt.trim().isEmpty) return;

    setState(() {
      _messages.add({"text": prompt, "isUser": true});
      _isGenerating = true;
    });

    // Clear input field
    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': prompt}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final answer = result['response'];
        _animateMessage(answer);
      } else {
        setState(() {
          _messages.add({"text": "Error: Unable to fetch response.", "isUser": false});
          _isGenerating = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({"text": "Error: $e", "isUser": false});
        _isGenerating = false;
      });
    }
  }

  void _animateMessage(String answer) async {
    List<String> words = answer.split(" ");
    String generatedText = "";

    for (var word in words) {
      await Future.delayed(Duration(milliseconds: 100));

      setState(() {
        generatedText += "$word ";
        if (_messages.isNotEmpty && !_messages.last['isUser']) {
          _messages[_messages.length - 1]['text'] = generatedText;
        } else {
          _messages.add({"text": generatedText, "isUser": false});
        }
      });
    }

    setState(() {
      _isGenerating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return _buildMessageBubble(message["text"], message["isUser"]);
              },
            ),
          ),
          if (_isGenerating)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(String message, bool isUser) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, 0.5),
            end: Offset(0, 0),
          ).animate(_animationController),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: isUser ? Color(0xFF006a94) : Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: isUser ? Radius.circular(12) : Radius.zero,
                bottomRight: isUser ? Radius.zero : Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              maxLines: 2,
              minLines: 1,
              decoration: InputDecoration(
                hintText: "Type your message...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          FloatingActionButton(
            onPressed: () {
              final prompt = _controller.text.trim();
              if (prompt.isNotEmpty) {
                _animationController.reset();
                _animationController.forward();
                _sendPrompt(prompt);
              }
            },
            backgroundColor: Color(0xFF006a94),
            child: Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
