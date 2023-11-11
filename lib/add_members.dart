import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddMembersINGroup extends StatefulWidget {
  final String groupChatId, name;
  final List membersList;
  const AddMembersINGroup({
    required this.name,
    required this.membersList,
    required this.groupChatId,
    Key? key,
  }) : super(key: key);

  @override
  _AddMembersINGroupState createState() => _AddMembersINGroupState();
}

class _AddMembersINGroupState extends State<AddMembersINGroup> {
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  List membersList = [];

  @override
  void initState() {
    super.initState();
    membersList = widget.membersList;
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs.isNotEmpty ? value.docs[0].data() : null;
        isLoading = false;
      });
    });
  }

  void onAddMembers() async {
    if (userMap != null) {
      membersList.add(userMap);

      await _firestore.collection('groups').doc(widget.groupChatId).update({
        "members": membersList,
      });

      await _firestore
          .collection('users')
          .doc(userMap!['uid'])
          .collection('groups')
          .doc(widget.groupChatId)
          .set({"name": widget.name, "id": widget.groupChatId});
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Members"),
        backgroundColor: Colors.grey[900],
      ),
      backgroundColor: Colors.grey[800],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: size.height / 20),
            TextField(
              controller: _search,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: size.height / 50),
            ElevatedButton(
              onPressed: onSearch,
              child: Text("Search"),
            ),
            if (isLoading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: CircularProgressIndicator(),
              ),
            if (userMap != null)
              ListTile(
                onTap: onAddMembers,
                leading: Icon(Icons.account_box, color: Colors.white),
                title: Text(
                  userMap!['name'],
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  userMap!['email'],
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Icon(Icons.add, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
