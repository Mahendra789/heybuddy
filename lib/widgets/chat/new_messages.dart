import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enterMessages = '';

  void _sendMessages() async {
    final currentuser = await FirebaseAuth.instance.currentUser();
    final userData = await Firestore.instance
        .collection('users')
        .document(currentuser.uid)
        .get();
    FocusScope.of(context).unfocus();
    Firestore.instance.collection('chat').add({
      'text': _enterMessages,
      'createdOn': Timestamp.now(),
      'userId': currentuser.uid,
      'username': userData['username'],
      'userimage': userData['image_url'],
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
              autocorrect: true,
              textCapitalization: TextCapitalization.sentences,
              enableSuggestions: false,
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
