import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:aaelectroz_fe/providers/auth_provider.dart';
import 'package:aaelectroz_fe/models/user_model.dart';
import 'package:aaelectroz_fe/services/auth_service.dart';

import 'auth_provider_test.mocks.dart';
// ✅ Pastikan file ini di-import

@GenerateMocks([AuthService])
void main() {
  late AuthProvider authProvider;
  late MockAuthService mockAuthService; // ✅ Pastikan mockAuthService dideklarasikan di sini

  setUp(() {
    mockAuthService = MockAuthService(); // ✅ Inisialisasi mock sebelum digunakan
    authProvider = AuthProvider(authService: mockAuthService); // ✅ Berikan ke AuthProvider
  });

  final userMock = UserModel(
    id: 1,
    name: "Test User",
    email: "test@example.com",
    username: "testuser",
    profilePhotoUrl: "https://example.com/photo.jpg",
    token: "mockToken",
  );

  group('AuthProvider Tests', () {
    test('Login sukses', () async {
      when(mockAuthService.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => userMock);

      final result = await authProvider.login(
        email: "test@example.com",
        password: "password123",
      );

      expect(result, true);
      expect(authProvider.user.token, "mockToken");
    });

    test('Login gagal', () async {
      when(mockAuthService.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(Exception("Gagal Login"));

      final result = await authProvider.login(
        email: "wrong@example.com",
        password: "wrongpass",
      );

      expect(result, false);
    });

    test('Register sukses', () async {
      when(mockAuthService.register(
        name: anyNamed('name'),
        username: anyNamed('username'),
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => userMock);

      final result = await authProvider.register(
        name: "Test User",
        username: "testuser",
        email: "test@example.com",
        password: "password123",
      );

      expect(result, true);
      expect(authProvider.user.name, "Test User");
    });

    test('Register gagal', () async {
      when(mockAuthService.register(
        name: anyNamed('name'),
        username: anyNamed('username'),
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(Exception("Gagal Register"));

      final result = await authProvider.register(
        name: "Test User",
        username: "testuser",
        email: "test@example.com",
        password: "password123",
      );

      expect(result, false);
    });

    test('Logout sukses', () async {
      when(mockAuthService.logout(any)).thenAnswer((_) async => true);

      final result = await authProvider.logout("mockToken");

      expect(result, true);
    });

    test('Logout gagal', () async {
      when(mockAuthService.logout(any)).thenThrow(Exception("Gagal Logout"));

      final result = await authProvider.logout("mockToken");

      expect(result, false);
    });
  });
}
