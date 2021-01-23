import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enterMessages = '';

  void _sendMessages() {
    FocusScope.of(context).unfocus();
    Firestore.instance.collection('chat').add({
      'text': _enterMessages,
      'createdOn': Timestamp.now(),
    });

    _controller.clear();
  }

  final _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enterMessages = value;
                });
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: _enterMessages.trim().isEmpty ? null : _sendMessages,
          ),
        ],
      ),
    );
  }
}