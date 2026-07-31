import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';

import '../models/chat_message.dart';
import '../models/device_model.dart';

class NearbyService extends ChangeNotifier {
  static const Strategy strategy = Strategy.P2P_CLUSTER;

  List<DeviceModel> devices = [];

  List<ChatMessage> messages = [];

  String? connectedEndpoint;

  bool isAdvertising = false;
  bool isDiscovering = false;
  bool isConnected = false;

  String userName = "User";

  Future<void> initialize(String name) async {
    userName = name;
  }

  Future<void> startAdvertising() async {
    isAdvertising = true;
    notifyListeners();

    await Nearby().startAdvertising(
      userName,
      strategy,
      onConnectionInitiated: _onConnectionInitiated,
      onConnectionResult: _onConnectionResult,
      onDisconnected: _onDisconnected,
    );
  }

  Future<void> stopAdvertising() async {
    await Nearby().stopAdvertising();

    isAdvertising = false;

    notifyListeners();
  }

  Future<void> startDiscovery() async {
    devices.clear();

    isDiscovering = true;

    notifyListeners();

    await Nearby().startDiscovery(
      userName,
      strategy,
      onEndpointFound: _onEndpointFound,
      onEndpointLost: _onEndpointLost,
    );
  }

  Future<void> stopDiscovery() async {
    await Nearby().stopDiscovery();

    isDiscovering = false;

    notifyListeners();
  }
    void _onEndpointFound(
    String endpointId,
    String endpointName,
    String serviceId,
  ) {
    final exists =
        devices.any((e) => e.endpointId == endpointId);

    if (!exists) {
      devices.add(
        DeviceModel(
          endpointId: endpointId,
          name: endpointName,
        ),
      );

      notifyListeners();
    }
  }

  void _onEndpointLost(String endpointId) {
    devices.removeWhere(
      (e) => e.endpointId == endpointId,
    );

    notifyListeners();
  }

  Future<void> connect(DeviceModel device) async {
    await Nearby().requestConnection(
      userName,
      device.endpointId,
      onConnectionInitiated: _onConnectionInitiated,
      onConnectionResult: _onConnectionResult,
      onDisconnected: _onDisconnected,
    );
  }  void _onConnectionInitiated(
    String endpointId,
    ConnectionInfo info,
  ) {
    Nearby().acceptConnection(
      endpointId,
      onPayLoadRecieved: (
        endpoint,
        payload,
      ) {
        if (payload.type == PayloadType.BYTES) {
          final text = String.fromCharCodes(
            payload.bytes!,
          );

          messages.add(
            ChatMessage(
              text: text,
              mine: false,
              time: DateTime.now(),
            ),
          );

          notifyListeners();
        }
      },
    );
  }
    void _onConnectionResult(
    String endpointId,
    Status status,
  ) {
    if (status == Status.CONNECTED) {
      connectedEndpoint = endpointId;

      isConnected = true;

      notifyListeners();
    }
  }

  void _onDisconnected(String endpointId) {
    connectedEndpoint = null;

    isConnected = false;

    notifyListeners();
  }
    Future<void> sendMessage(
    String text,
  ) async {
    if (connectedEndpoint == null) return;

    await Nearby().sendBytesPayload(
      connectedEndpoint!,
      Uint8List.fromList(
        text.codeUnits,
      ),
    );

    messages.add(
      ChatMessage(
        text: text,
        mine: true,
        time: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  Future<void> disconnect() async {
    if (connectedEndpoint != null) {
      await Nearby().disconnectFromEndpoint(
        connectedEndpoint!,
      );
    }

    connectedEndpoint = null;

    isConnected = false;

    notifyListeners();
  }
}
  
