import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignOut extends StatelessWidget {
  const SignOut({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        dropdownColor: const Color.fromARGB(255, 151, 71, 255),
        icon: Icon(
          Icons.more_vert,
          color: Theme.of(context).primaryIconTheme.color,
        ),
        items: [
          DropdownMenuItem(
            value: "logout",
            child: Row(
              children: const [
                Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
                SizedBox(width: 8),
                Text("Logout"),
              ],
            ),
          ),
        ],
        onChanged: (item) {
          if (item == "logout") {
            FirebaseAuth.instance.signOut();
          }
        });
  }
}
