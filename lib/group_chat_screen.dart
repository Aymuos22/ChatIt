import 'package:chatit/add_grp_members.dart';
import 'package:chatit/group_chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupChatHomeScreen extends StatefulWidget {
  const GroupChatHomeScreen({Key? key}) : super(key: key);

  @override
  _GroupChatHomeScreenState createState() => _GroupChatHomeScreenState();
}

class _GroupChatHomeScreenState extends State<GroupChatHomeScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late List<DocumentSnapshot> groupList;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAvailableGroups();
  }

  void getAvailableGroups() async {
    String uid = _auth.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('groups')
        .get();

    setState(() {
      groupList = querySnapshot.docs;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Groups"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: groupList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> groupData =
                    (groupList[index].data() as Map<String, dynamic>);
                return ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => GroupChatRoom(
                          groupName: groupData['name'],
                          groupChatId: groupData['id'],
                        ),
                      ),
                    );
                  },
                  leading: Icon(Icons.group),
                  title: Text(groupData['name']),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.create),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => AddMembersInGroup(),
            ),
          );
        },
        tooltip: "Create Group",
      ),
    );
  }
}
