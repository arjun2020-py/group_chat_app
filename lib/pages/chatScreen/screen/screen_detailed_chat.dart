import 'package:chat_app/firebase_section/autication.dart';
import 'package:chat_app/utils/custom_text_widget.dart';
import 'package:chat_app/utils/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/chat_screen_cubit.dart';

class ScreenDetailedChat extends StatelessWidget {
  ScreenDetailedChat({super.key, required this.emailId,}) {
    _stream = collectionReference.snapshots();
  }
  final String emailId;


  //collection 'chat_collection'
  var collectionReference = FirebaseFirestore.instance
      .collection('chat_collection')
      .orderBy("time"); //sort the message based on the orderBy function

//intsance of Stream
  late Stream<QuerySnapshot> _stream;
  FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatScreenCubit(context),
      child: BlocBuilder<ChatScreenCubit, ChatScreenState>(
        builder: (context, state) {
          var cubit = context.read<ChatScreenCubit>();

          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              flexibleSpace: SafeArea(
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/images/prof1.jpg"),
                        maxRadius: 20,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                             emailId,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Online",
                              style: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton(
                        icon: Icon(Icons.settings),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              child: InkWell(
                            onTap: () => firebaseAuthServices.siginOut(context),
                            child: CustomTextWidget(
                                text: 'sigin Out',
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: StreamBuilder<QuerySnapshot>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    chatAppShowToast(
                        message: 'some error is occured ${snapshot.error}');
                  }
                  if (snapshot.hasData) {
                    cubit.emailId = emailId;

                    print('email______id${cubit.emailId}');
                    //get the data.
                    QuerySnapshot<Object?>? querySnapshot = snapshot.data;
                    List<QueryDocumentSnapshot> documents = querySnapshot!.docs;

                    //convert the documents into map

                    List<Map> items = documents
                        .map((e) => {
                              'id': e.id,
                              'message': e['message'],
                              'time': e['time'],
                              'type': e['type']
                            })
                        .toList();
                    return Stack(
                      children: <Widget>[
                        ListView.builder(
                          itemCount: items.length,
                          shrinkWrap: true,
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          // physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            Map chatItem = items[index];

                            return Container(
                              padding: EdgeInsets.only(
                                  left: 14, right: 14, top: 10, bottom: 10),
                              child: Align(
                                alignment: chatItem['type'] == emailId
                                    ? Alignment.topRight
                                    : Alignment.topLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: chatItem['type'] == emailId
                                          ? Colors.blue[400]
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(15)),
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      Text(chatItem['message']),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 25),
                                        child: CustomTextWidget(
                                            text: chatItem['time'],
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding:
                                EdgeInsets.only(left: 10, bottom: 10, top: 10),
                            height: 60,
                            width: double.infinity,
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    controller: cubit.messageController,
                                    decoration: InputDecoration(
                                        hintText: "Write message...",
                                        hintStyle:
                                            TextStyle(color: Colors.black54),
                                        border: InputBorder.none),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                FloatingActionButton(
                                  onPressed: () {
                                    cubit.messageButtonClick();
                                  },
                                  child: Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  backgroundColor: Colors.blue,
                                  elevation: 0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }

                  return Center(child: CircularProgressIndicator());
                }),
          );
        },
      ),
    );
  }
}
