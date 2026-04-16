import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../../core/token_manager.dart';
import '../../../../core/constants.dart';

class OrdersSocketManager {
  final TokenManager tokenManager;
  io.Socket? _socket;
  final _orderStatusController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get orderStatusUpdates =>
      _orderStatusController.stream;

  OrdersSocketManager({required this.tokenManager});

  Future<void> connect() async {
    final token = await tokenManager.getAccessToken();
    if (token == null) return;

    _socket = io.io(
      '${AppConstants.baseUrl}/orders',
      io.OptionBuilder().setTransports(['websocket']).setAuth({
        'token': token,
      }).build(),
    );

    _socket!.onConnect((_) => print('Connected to orders socket'));

    _socket!.on('orderStatusUpdated', (data) {
      _orderStatusController.add(data);
    });

    _socket!.onDisconnect((_) => print('Disconnected from orders socket'));
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  void dispose() {
    _orderStatusController.close();
    disconnect();
  }
}
