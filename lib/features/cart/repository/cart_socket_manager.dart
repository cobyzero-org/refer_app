import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../../core/token_manager.dart';
import '../../../core/constants.dart';
import '../model/cart_item.dart';

class CartSocketManager {
  final TokenManager tokenManager;
  io.Socket? socket;
  Function(CartUpdateResponse)? onCartUpdated;

  CartSocketManager({required this.tokenManager});

  void connect() async {
    final token = await tokenManager.getAccessToken();
    if (token == null) return;

    socket = io.io(
      AppConstants.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableAutoConnect()
          .build(),
    );

    socket?.onConnect((_) {
      print('Connected to /cart namespace');
    });

    socket?.on('cartUpdated', (data) {
      if (onCartUpdated != null) {
        onCartUpdated!(CartUpdateResponse.fromJson(data));
      }
    });

    socket?.onDisconnect((_) => print('Disconnected from /cart namespace'));
    socket?.onError((err) => print('Socket error: $err'));
  }

  void addToCart({
    required String productId,
    required String? sizeId,
    required String? typeId,
    required List<String> enhancementIds,
    required int quantity,
  }) {
    socket?.emit('addToCart', {
      'productId': productId,
      'sizeId': sizeId,
      'typeId': typeId,
      'enhancementIds': enhancementIds,
      'quantity': quantity,
    });
  }

  void removeItem(String cartItemId) {
    socket?.emit('removeItem', cartItemId);
  }

  void updateQuantity(String cartItemId, int quantity) {
    socket?.emit('updateQuantity', {
      'itemId': cartItemId,
      'quantity': quantity,
    });
  }

  void clearCart() {
    socket?.emit('clearCart');
  }

  void disconnect() {
    socket?.disconnect();
    socket = null;
  }
}
