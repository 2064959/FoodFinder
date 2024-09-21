// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tpfinal/database_helper.dart';
import 'package:tpfinal/main.dart';
import 'package:tpfinal/model/user.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    super.key,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.all(0.0),
                        padding: const EdgeInsets.only(bottom: 20),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromARGB(255, 176, 176, 176),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            
                            TextButton(
                              style: const ButtonStyle(
                                alignment: Alignment.centerLeft,
                                padding: WidgetStatePropertyAll(EdgeInsets.zero)
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: Row(
                                children: [
                                  const Icon(Icons.arrow_back),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: const Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text('easyGrocery '),
                                        Text('v0.1.0' , style: TextStyle(fontSize: 10, ),),
                                      ],
                                    )
                                  )
                                ],
                              )
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(top: 20, bottom: 20),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color.fromARGB(255, 176, 176, 176),
                                  width: 0.5,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () => {}, 
                                        icon: const Icon(Icons.account_circle_outlined)
                                      ),
                                      FutureBuilder<UserModel?>(
                                        future: DatabaseHelper().getUserWithId(FirebaseAuth.instance.currentUser!.uid),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text('Error: ${snapshot.error}');
                                          } else if (snapshot.hasData) {
                                            UserModel? user = snapshot.data;
                                            
                                            return Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text( user!.username, style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(0, 173, 72, 1)),),
                                                Text( user.email, style: const TextStyle(fontSize: 10,color: Color.fromARGB(255, 94, 94, 94),),),
                                              ],
                                            );
                                          } else {
                                            return const Text('No data');
                                          }
                                        }
                                      ),

                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () => {}, 
                                    icon: const Icon(Icons.more_horiz,color: Color.fromARGB(255, 94, 94, 94),)
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                              style: const ButtonStyle(
                                alignment: Alignment.centerLeft,
                                padding: WidgetStatePropertyAll(EdgeInsets.zero)
                              ),
                              onPressed: () {},
                              child: Row(
                                children: [
                                  const Icon(Icons.notifications_active_outlined),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: const Text('Notifications')
                                  )
                                ],
                              )
                            ),
                            TextButton(
                              style: const ButtonStyle(
                                alignment: Alignment.centerLeft,
                                padding: WidgetStatePropertyAll(EdgeInsets.zero)
                              ),
                              onPressed: () {},
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_month_outlined),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: const Text('Calendar'),
                                  )
                                ],
                              )
                            ),
                            TextButton(
                              style: const ButtonStyle(
                                alignment: Alignment.centerLeft,
                                padding: WidgetStatePropertyAll(EdgeInsets.zero)
                              ),
                              onPressed: () async {

                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.chat_outlined),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: const Text('Chat')
                                  )
                                ],
                              )
                            ),
                            TextButton(
                              style: const ButtonStyle(
                                alignment: Alignment.centerLeft,
                                padding: WidgetStatePropertyAll(EdgeInsets.zero)
                              ),
                              onPressed: () {},
                              child: Row(
                                children: [
                                  const Icon(Icons.people_outline_outlined),
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: const Text('Friends')
                                  )
                                ],
                              )
                            ),
                            
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 30, bottom: 10),
                            child: const Text(
                              'MORE INFO',
                              style: TextStyle(
                                color: Color.fromARGB(255, 94, 94, 94),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            style: const ButtonStyle(
                              alignment: Alignment.centerLeft,
                              padding: WidgetStatePropertyAll(EdgeInsets.zero)
                            ),
                            onPressed: () {},
                            child: Row(
                              children: [
                                const Icon(Icons.help_center_outlined),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: const Text('Help Center')
                                )
                              ],
                            )
                          ),
                          TextButton(
                            style: const ButtonStyle(
                              alignment: Alignment.centerLeft,
                              padding: WidgetStatePropertyAll(EdgeInsets.zero)
                            ),
                            onPressed: () {},
                            child:Row(
                              children: [
                                const Icon(Icons.info_outline),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: const Text('About Us')
                                )
                              ],
                            )
                          ),
                          TextButton(
                            style: const ButtonStyle(
                              alignment: Alignment.centerLeft,
                              padding: WidgetStatePropertyAll(EdgeInsets.zero)
                            ),
                            onPressed: () {},
                            child:Row(
                              children: [
                                const Icon(Icons.tune_outlined),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: const Text('Settings')
                                )
                              ],
                            )
                          ),
                          
                        ],
                      ),
                  ],
                ),
                
                TextButton(
                  style: const ButtonStyle(
                    alignment: Alignment.centerLeft,
                    padding: WidgetStatePropertyAll(EdgeInsets.zero)
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    LogOutConfirmation(context);
                  },
                  child:Row(
                    children: [
                      const Icon(Icons.logout_outlined,color: Colors.red,),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: const Text(
                          'Log out', 
                          style: TextStyle(color: Colors.red),
                        )
                      )
                    ],
                  )
                ),
        ],
      ),
      
    );
  }

  Future<String?> LogOutConfirmation(BuildContext context) {
    return showDialog<String>(
      context: context,

      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: const Text('Log Out?'),
        content: const Text('Are you sure you want to log out?'),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 176, 176, 176),
                  borderRadius: BorderRadius.circular(5),
                ),
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
              ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context, 'Cancel');
              // Call the signOut method when the logout button is pressed
              await Provider.of<AppState>(context, listen: false).signOut();
            },
            child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 173, 72, 1),
                  borderRadius: BorderRadius.circular(5),
                ),
              child: const Text('Log out', style: TextStyle(color: Colors.white)),
              ),
          ),
        ],
      ),
    );
  }

}
