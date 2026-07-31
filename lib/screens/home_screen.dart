import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/nearby_service.dart';
import '../widgets/device_tile.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController nameController =
      TextEditingController(text: "User");

  @override
  Widget build(BuildContext context) {
    final nearby = context.watch<NearbyService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Offline Chat"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Your Name",
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await nearby.initialize(nameController.text);
                    await nearby.startAdvertising();
                  },
                  child: const Text("Advertise"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await nearby.initialize(nameController.text);
                    await nearby.startDiscovery();
                  },
                  child: const Text("Discover"),
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: nearby.devices.length,
              itemBuilder: (_, index) {
                return DeviceTile(
                  device: nearby.devices[index],
                  onConnect: () async {
                    await nearby.connect(
                      nearby.devices[index],
                    );

                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChatScreen(),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
