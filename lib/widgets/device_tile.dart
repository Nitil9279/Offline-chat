import 'package:flutter/material.dart';
import '../models/device_model.dart';

class DeviceTile extends StatelessWidget {
  final DeviceModel device;
  final VoidCallback onConnect;

  const DeviceTile({
    super.key,
    required this.device,
    required this.onConnect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.phone_android),
        ),
        title: Text(device.name),
        subtitle: Text(device.endpointId),
        trailing: ElevatedButton(
          onPressed: onConnect,
          child: const Text("Connect"),
        ),
      ),
    );
  }
}
