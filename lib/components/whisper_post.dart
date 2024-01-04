import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whisper/components/comment_button.dart';
import 'package:whisper/components/comments.dart';
import 'package:whisper/components/like.dart';
import 'package:whisper/helpers/helper_time.dart';

class WhisperPost extends StatefulWidget {
  const WhisperPost({
    super.key,
    required this.message,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
    required this.commentCount
  });
  final String time;
  final String message;
  final String user;
  final String postId;
  final List<String> commentCount;
  final List<String> likes;


  @override
  State<WhisperPost> createState() => _WhisperPostState();
}

class _WhisperPostState extends State<WhisperPost> {
  //User
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final commentTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  //toggle like and unlike
  void toggleLike(){
    setState(() {
      isLiked = !isLiked;
    });

    //Store the state of like in firebase
    DocumentReference docRef =
       FirebaseFirestore.instance.collection('User posts').doc(widget.postId);

    if(isLiked){
      //if liked, record like
      docRef.update({
        'Likes': FieldValue.arrayUnion([currentUser.email])
      });
    }else{
      //if unliked, remove like
      docRef.update({
        'Likes': FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  //Add comments
  void addComment(String commentText){
    //write comment to fireStore, into the comments collection
    FirebaseFirestore.instance
        .collection("User posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({

      "CommentText": commentText,
      "CommenterID": currentUser.email,
      "CommentTime": Timestamp.now(),
    });

    //Store the state of comment in firebase
    DocumentReference docRef =
    FirebaseFirestore.instance.collection('User posts').doc(widget.postId);

    if(isLiked){
      //if liked, record like
      docRef.update({
        'Comments': FieldValue.arrayUnion([currentUser.email])
      });
    }else{
      //if unliked, remove like
      docRef.update({
        'Comments': FieldValue.arrayRemove([currentUser.email])
      });
    }

  }

  //Show comment dialog for adding it

  void showCommentDialog(){
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text("Add a comment"),
      content: TextField(
        controller: commentTextController,
        decoration: const InputDecoration(
          hintText: "Join this discussion",
        ),
      ),
      actions: [
        //Cancel comment button
        TextButton(
            onPressed: (){
              //Pop dialog
              Navigator.pop(context);

              //Clear controller
              commentTextController.clear();

            },
            child: const Text(
                "C A N C E L",
              style: TextStyle(
                color: Colors.redAccent,
              ),
            )
        ),
        //submit comment button
        TextButton(
            onPressed: (){
              //ad comment
              addComment(commentTextController.text);

              //Clear controller
              commentTextController.clear();

              //Pop dialog
              Navigator.pop(context);
              },
            child: const Text(
              "S U B M I T",
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            )
        ),
      ],
    ));
  }

  //final String time;
  @override
  Widget build(BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              width: 1,
              color: const Color(0xffFFA732)
          ),
        ),
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //profile picture
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                      Icons.person_2_outlined,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                //Whisper and user email
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Text(
                              widget.user,
                            style: const TextStyle(
                                color: Color(0xffFFA732),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        Text(
                          " • ${widget.time}",
                          style: const TextStyle(
                            color: Color(0xffFFA732),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 180,
                      child: Flexible(
                        child: Text(
                            widget.message,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                //comments
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Comment button
                    CommentButton(
                      onTap: showCommentDialog,
                    ),
                    Text(
                        widget.commentCount.length.toString()
                    ),
                  ],
                ),

                const SizedBox(width: 10,),

                Column(
                  children: [
                    //like button
                    LikeButton(
                      isLiked: isLiked,
                      onTap: toggleLike,
                    ),

                    //like count
                    Text(
                      widget.likes.length.toString()
                    ),
                  ],
                ),

              ],
            ),

            //Display comments

            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("User posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .orderBy("CommentTime", descending: true)
                    .snapshots(),
                builder: (context, snapshot){

                  //Loading..
                  if(!snapshot.hasData){
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  //return comments
                  return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: snapshot.data!.docs.map((doc){
                      //get comments
                      final commentData = doc.data() as Map<String, dynamic>;

                      //return comments
                      return Comment(
                        user: commentData['CommenterID'],
                        text: commentData['CommentText'],
                        time: formatTime(commentData['CommentTime']),
                      );
                    }).toList(),
                  );
                }),
          ],
        )
      );
    }
  }
