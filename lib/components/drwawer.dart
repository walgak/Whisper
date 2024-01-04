import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:whisper/components/list_tile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOutTap;

  const MyDrawer({
    super.key,
    this.onProfileTap,
    this.onSignOutTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Header
          const DrawerHeader(child: Icon(
            CupertinoIcons.person,
            color: Color(0xff004252),
            size: 100,
          ),),

          //Home
          MyListTile(
            icon: Icons.home_filled,
            text: "H O M E",
            onTap: () => Navigator.pop(context),
          ),
          //Profile
          MyListTile(
            icon: Icons.person,
            text: "P R O F I L E",
            onTap: onProfileTap,
          ),

          //Logout
          const Spacer(),

          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 28.0),
                child: GestureDetector(
                  onTap: onSignOutTap,
                  child: const Text(
                    "L O G O U T",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
