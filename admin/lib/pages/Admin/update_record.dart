import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zero/styles/color.dart';

class UpdateRecord extends StatefulWidget {
  const UpdateRecord({Key? key, required this.userKey}) : super(key: key);

  final String userKey;

  @override
  State<UpdateRecord> createState() => _UpdateRecordState();
}

class _UpdateRecordState extends State<UpdateRecord> {
  final userNameController = TextEditingController();
  final userEmailController = TextEditingController();
  final userPasswordController = TextEditingController();
  final userPhoneNumberController = TextEditingController();

  late FirebaseFirestore firestore;

  @override
  void initState() {
    super.initState();
    firestore = FirebaseFirestore.instance;
    getUserData();
  }

  void getUserData() async {
    DocumentSnapshot snapshot =
        await firestore.collection('Users').doc(widget.userKey).get();

    Map<String, dynamic> users = snapshot.data() as Map<String, dynamic>;

    userNameController.text = users['User Name'];
    userEmailController.text = users['Email'];
    userPasswordController.text = users['Password'];
    userPhoneNumberController.text = users['Phone Number'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: topbar,
          title: Text('Updating User Details', style: TextStyle(fontSize: 24)),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: userNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                        hintText: 'Enter Your User Name',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: userEmailController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        hintText: 'Enter Your Email',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: userPasswordController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        hintText: 'Enter Your Password',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: userPhoneNumberController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Phone Number',
                        hintText: 'Enter Your Phone Number',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    MaterialButton(
                      onPressed: () {
                        Map<String, dynamic> users = {
                          'User Name': userNameController.text,
                          'Email': userEmailController.text,
                          'Password': userPasswordController.text,
                          'Phone Number': userPasswordController.text,
                        };

                        firestore
                            .collection('Users')
                            .doc(widget.userKey)
                            .update(users)
                            .then((value) => Navigator.pop(context));
                      },
                      child: const Text(
                        'Update Data',
                        style: TextStyle(fontSize: 16),
                      ),
                      color: lightbrown,
                      textColor: Colors.black,
                      minWidth: 390,
                      height: 53,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        )
      );
  }
}
