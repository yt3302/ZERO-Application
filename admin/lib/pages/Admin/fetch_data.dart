import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zero/pages/Admin/update_record.dart';
import 'package:zero/pages/Welcome/signinpage.dart';
import 'package:zero/styles/color.dart';

class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  void logout() async {
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => const SignInPage());
    // setState(() {});
  }

  CollectionReference<Map<String, dynamic>> dbRef =
      FirebaseFirestore.instance.collection('Users');

  Widget listItem({required DocumentSnapshot<Map<String, dynamic>> snapshot}) {
  Map<String, dynamic> users = snapshot.data()!;
  users['key'] = snapshot.id;

  return Container(
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(10),
    height: 180,
    color: lightbrown,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Name: ${users['User Name'] ?? 'N/A'}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          "Email: ${users['Email'] ?? 'N/A'}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          "Password: ${users['Password'] ?? 'N/A'}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          "Phone Number: ${users['Phone Number'] ?? 'N/A'}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          "Role: ${users['Selected Role'] ?? 'N/A'}",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpdateRecord(userKey: users['key']),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Delete Account"),
                      content: Text(
                          "Are you sure you want to delete this account? "),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancel",
                              style: TextStyle(color: Colors.red)),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Perform the delete account operation
                            dbRef.doc(users['key']).delete();
                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: Text("Confirm"),
                        ),
                      ],
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red[700],
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: topbar,
        title: const Text(
          'Manage User',
          style: TextStyle(fontSize: 24),
        ),
        actions: [
          Transform.translate(
            offset: Offset(0, 1),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Logout"),
                    content: Text("Are you sure you want to logout? "),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                        child:
                            Text("Cancel", style: TextStyle(color: Colors.red)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Perform the delete account operation
                          logout();

                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                        child: Text("Confirm"),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.logout),
              color: word,
            ),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: dbRef.snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }

            List<DocumentSnapshot<Map<String, dynamic>>> documents =
                snapshot.data.docs;

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (BuildContext context, int index) {
                return listItem(snapshot: documents[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
