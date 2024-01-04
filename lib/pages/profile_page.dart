import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whisper/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  //obtaining user email
  final currentUser = FirebaseAuth.instance.currentUser!;

  final users = FirebaseFirestore.instance.collection("Users");

  //Edit user name
  Future<void> editField(String field) async{
    String newValue = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: const Color(0xff004252),
          title: Text(
            "Edit $field",
            style: const TextStyle(),
          ),
          content: TextField(
            autofocus: true,
            autocorrect: true,
            decoration: InputDecoration(
              hintText: "Enter your new $field",
              hintStyle: const TextStyle(
                color: Colors.grey
              ),
            ),
            onChanged: (value){
              newValue = value;
            },
          ),
          actions: [
            //Cancel changes
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.redAccent
                  ),
                )),

            //Save changes
            TextButton(
                onPressed: () => Navigator.of(context).pop(newValue),
                child: const Text(
                  "Confirm",
                  style: TextStyle(
                      color: Colors.blue
                  ),
                )
            ),
          ],
        )
    );

    //update change to firebase firestore
    if(newValue.trim().isNotEmpty){
      //Update data
      await users.doc(currentUser.email).update({field: newValue});
    }
  }

  //Profile picture
  void profilePicture(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfilePage()
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff004252),
        title: const Text(
          "Profile Page"
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').doc(currentUser.email).snapshots(),
        builder: (context, snapshot) {
          //Retrieve user data
          if(snapshot.hasData){
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                //profile picture
                const SizedBox(height: 50,),

                const Icon(
                  Icons.person_2_outlined,
                  color: Color(0xff004252),
                  size: 150,
                ),
                IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.edit)
                ),

                //user email
                const SizedBox(height: 10,),
                Text(
                  currentUser.email!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xff004252),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),

                //user details
                const SizedBox(height: 50,),

                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 25.0, right: 10.0),
                        child: Text(
                          "Details",
                          style: TextStyle(
                            color: Color(0xff004252),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                            height: 1,
                            decoration: const BoxDecoration(
                              color: Color(0xff004252),
                            ),
                          )),
                    ],
                  ),
                ),


                //user name

                MyTextBox(
                    onPressed: () => editField('username'),
                    text: userData["username"],
                    section: "User name"
                ),

                //bio
                MyTextBox(
                    onPressed: () => editField('bio'),
                    text: userData["bio"],
                    section: "Bio"
                ),

                const SizedBox(height: 50,),
                //user posts

                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 25.0, right: 10.0),
                        child: Text(
                          "Posts",
                          style: TextStyle(
                            color: Color(0xff004252),
                          ),
                        ),
                      ),
                      Expanded(
                          child: Container(
                            height: 1,
                            decoration: const BoxDecoration(
                              color: Color(0xff004252),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            );
          } else if(snapshot.hasError){
            return const Center(
              child: Text("Something went wrong!"),
            );
          }else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }
}
