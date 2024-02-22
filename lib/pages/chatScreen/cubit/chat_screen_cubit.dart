import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'chat_screen_state.dart';

class ChatScreenCubit extends Cubit<ChatScreenState> {
  ChatScreenCubit(this.context) : super(ChatScreenInitial());
  BuildContext context;
  final TextEditingController messageController = TextEditingController();
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('chat_collection');

  // CollectionReference chatTileCollection =
  //     FirebaseFirestore.instance.collection('user_chat_collection');

  late Stream<QuerySnapshot> _stream;
  String? emailId;
  String? name;
  messageButtonClick() async {
    String message = messageController.text;
    //using the above convter get crropding am or pm
    var time = DateFormat('hh:mm a').format(DateTime.now());

    Map<String, String> dataToSend = {
      "message": message,
      "time": time.toString(),
      "type": emailId!
    };

    collectionReference.add(dataToSend);
    messageController.clear();
  }

 
}
