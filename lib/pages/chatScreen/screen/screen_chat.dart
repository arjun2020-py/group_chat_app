import 'package:chat_app/pages/chatScreen/screen/screen_detailed_chat.dart';
import 'package:chat_app/utils/custom_text_widget.dart';
import 'package:chat_app/utils/custom_toast_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../firebase_section/autication.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({
    super.key,
    required this.email,
  }) {
    stream = reff.snapshots();
  }
  FirebaseAuthServices firebaseAuthServices = FirebaseAuthServices();
  var reff =
      FirebaseFirestore.instance.collection('user_chat_collection').orderBy('lastActive',descending: true);
  late Stream<QuerySnapshot> stream;
  

  bool isMessageRead = false;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.blue.withOpacity(0.7),
        actions: [
          IconButton(
              onPressed: () {
                firebaseAuthServices.siginOut(context);
              },
              icon: Icon(Icons.logout))
        ],
        title: Text('Chat App'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              chatAppShowToast(
                  message: 'some error is occured${snapshot.error}');
            }

            if (snapshot.hasData) {
              //create the instance of collection refernce
              QuerySnapshot<Object?>? querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> documents = querySnapshot!.docs;

              //convert document to map  of list
              List<Map> items = documents
                  .map((e) => {
                        'email': e['email'],
                        'name': e['name'],
                        'lastActive': e['lastActive']
                      })
                  .toList();

              return SafeArea(
                  child: ListView.separated(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  var chatTileItem = items[index];
                  var name  = chatTileItem['name'];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ScreenDetailedChat(emailId: email, ),
                        )),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 16, right: 16, top: 10, bottom: 10),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      backgroundImage:
                                          AssetImage('assets/images/prof1.jpg'),
                                      maxRadius: 30,
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              chatTileItem['name'],
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                              children: [
                                                CustomTextWidget(
                                                    text: 'Last Active:',
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                CustomTextWidget(
                                                    text: chatTileItem['lastActive'],
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500)
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    thickness: 0.2,
                    color: Colors.black.withOpacity(0.5),
                  );
                },
              ));
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
