import 'package:flutter/material.dart';
import 'package:fyp_1/utils/colors.dart';

class ChatHome extends StatelessWidget {
  ChatHome({super.key});
  final List<ChatItem> chats = [
    ChatItem(
        name: "Joseph Amhed",
        message: "ok sure",
        time: "2h",
        imageUrl: "assets/images/default.png"),
    ChatItem(
        name: "Marvis Queen",
        message: "Task is related to flutter developmen...",
        time: "3h",
        imageUrl: "assets/images/default.png"),
    ChatItem(
        name: "Ejaz Akhter",
        message: "You missed a video call with Ejaz.",
        time: "4h",
        imageUrl: "assets/images/default.png"),
    // Add more chat items here
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tSecondaryColor,
      appBar: AppBar(
        backgroundColor: tPrimaryColor,
        title: Text("Messages"),
        actions: [
          IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          return ChatItemWidget(
            chatItem: chats[index],
          );
        },
      ),
    );
  }
}

class ChatItemWidget extends StatelessWidget {
  final ChatItem chatItem;

  ChatItemWidget({required this.chatItem});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage(chatItem.imageUrl),
      ),
      title: Text(chatItem.name),
      subtitle: Text(chatItem.message),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(chatItem.time),
          Icon(Icons.done_all, color: Colors.blue), // Message read indicator
        ],
      ),
      onTap: () {
        // Navigate to chat detail screen
      },
    );
  }
}

class ChatItem {
  final String name;
  final String message;
  final String time;
  final String imageUrl;

  ChatItem(
      {required this.name,
      required this.message,
      required this.time,
      required this.imageUrl});
}
