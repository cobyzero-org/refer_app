abstract class AuthRepository {
  Future<bool> login(String email, String password);
  Future<bool> signup(String name, String email, String password);
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<bool> login(String email, String password) async {
    // Mock login service
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Future<bool> signup(String name, String email, String password) async {
    // Mock signup service
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }
}
