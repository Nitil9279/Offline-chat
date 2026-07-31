import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/nearby_service.dart';
import '../widgets/chat_input.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final nearby = context.watch<NearbyService>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Offline Chat"),

        actions: [
          IconButton(
            icon: const Icon(Icons.link_off),
            onPressed: () async {
              await nearby.disconnect();

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),

      body: Column(
        children: [

          if (nearby.isConnected)
            Container(
              width: double.infinity,
              color: Colors.green,
              padding: const EdgeInsets.all(8),
              child: const Text(
                "Connected",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),

          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: nearby.messages.length,
              itemBuilder: (_, index) {
                return MessageBubble(
                  message: nearby.messages[index],
                );
              },
            ),
          ),

          ChatInput(
            controller: controller,
            onSend: () async {
              if (controller.text.trim().isEmpty) return;

              await nearby.sendMessage(
                controller.text.trim(),
              );

              controller.clear();
            },
          )
        ],
      ),
    );
  }
}
