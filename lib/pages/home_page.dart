import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whisper/components/drwawer.dart';
import 'package:whisper/components/text_field.dart';
import 'package:whisper/helpers/helper_time.dart';
import 'package:whisper/pages/profile_page.dart';

import '../components/whisper_post.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //user

  final currentUser = FirebaseAuth.instance.currentUser!;

  //text controller
  final textController = TextEditingController();

  //sign out
  void signOut() async{
    await FirebaseAuth.instance.signOut();
  }

  //post a whisper
  void postWhisper(){
    //post if there is text text field
    if(textController.text.isNotEmpty){
      //store the data in firestore
      FirebaseFirestore.instance.collection("User posts").add({
        'UserEmail': currentUser.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
        'Comments': [],
      });
    }
    //clear text

    setState(() {
      textController.clear();
    });
  }

  void postWhisperAnon(){
    //post if there is text text field
    if(textController.text.isNotEmpty){
      //store the data in firestore
      FirebaseFirestore.instance.collection("User posts").add({
        'UserEmail': "Unknown",
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
        'Comments': [],
      });
    }
    //clear text

    setState(() {
      textController.clear();
    });
  }

  //Navigate to profile page
  void goToProfilePage() {
    //pop the menu drawer
    Navigator.pop(context);

    //go to the profile page
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context)=> const ProfilePage())
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "THE WHISPER",
          style: TextStyle(
            color: Color(0xff004252),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xff004252),
        ),
      ),

      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOutTap: signOut,
      ),
      body: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xfff8f8f8),
          ),
          child: Column(
            children: [
              //the whisper
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("User posts").orderBy(
                        "TimeStamp", descending: false).snapshots(),
                    builder: (context, snapshots){
                      if(snapshots.hasData){
                        return ListView.builder(
                            itemCount: snapshots.data!.docs.length,
                            itemBuilder: (context, index){
                              //get the whisper
                              final post = snapshots.data!.docs[index];
                              return WhisperPost(
                                time: formatTime(post['TimeStamp']),
                                message: post['Message'],
                                user: post['UserEmail'],
                                postId: post.id,
                                likes: List<String>.from(post['Likes']?? []),
                                commentCount: List<String>.from(post['Comments']?? []),);
                            }
                        );
                      }else{
                        if(snapshots.hasError){
                          return Center(
                            child: Text("Error ${snapshots.error}"),
                          );
                        }else {
                          return const Center(
                          child: CircularProgressIndicator(),
                        );
                        }
                      }
                    }),
              ),
              //post message
              Padding(
                padding: const EdgeInsets.only(top: 30,bottom: 15, left: 30),
                child: Row(
                  children: [
                    //post a whisper
                    Expanded(
                        child: MyTextField(
                          controller: textController,
                          hintText: "Whisper a thoughts",
                          obscure: false,
                        )
                    ),

                    const SizedBox(width: 15,),

                    //post button
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: IconButton(
                        onPressed: postWhisper,
                        icon: const Icon(Icons.arrow_circle_up),
                        color: const Color(0xff004252),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: IconButton(
                        onPressed: postWhisperAnon,
                        icon: const Icon(Icons.person_off),
                        color: const Color(0xffFFA732),
                      ),
                    )
                  ],
                ),
              ),

              //logged in as
              Text(
                "Signed in as ${currentUser.email!}",
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
