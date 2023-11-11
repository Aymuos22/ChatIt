import 'package:chatit/aichatscreen.dart';
import 'package:flutter/material.dart';
import 'package:chatit/LoginScreen.dart';
import 'package:chatit/Methods.dart';
import 'package:chatit/Authenticate.dart';
import 'package:chatit/ChatRoom.dart';
import 'package:chatit/group_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      "status": status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('users')
        .where("email", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "CHATiT",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: size.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextField(
                    controller: _search,
                    style: TextStyle(
                        color: Colors.black), // Set text color to black
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              color: Colors.black,
              onPressed: onSearch,
            ),
            IconButton(
              icon: Icon(Icons.logout),
              color: Colors.black,
              onPressed: () => logOut(context),
            ),
          ],
        ),
        backgroundColor: Colors.grey[900], // Set background color to dark theme
        body: Column(
          children: [
            // Add your AI message here
            ListTile(
              leading: Icon(Icons.android, color: Colors.white),
              title: Text(
                "Your AI",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                "AI Bot",
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => AIChatScreen()));
              },
              trailing: Icon(Icons.chat, color: Colors.white),
            ),
            
            if (userMap != null)
              ListTile(
                onTap: () {
                  String roomId = chatRoomId(
                      _auth.currentUser!.displayName!, userMap!['name']);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ChatRoom(
                        chatRoomId: roomId,
                        userMap: userMap!,
                      ),
                    ),
                  );
                },
                leading: Icon(Icons.account_box, color: Colors.white),
                title: Text(
                  userMap!['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  userMap!['email'],
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: Icon(Icons.chat, color: Colors.white),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.group),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => GroupChatHomeScreen(),
            ),
          ),
        ));
  }
}
