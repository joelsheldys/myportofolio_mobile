import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';

void main() {
  test('logout clears local token even when server logout fails', () async {
    final apiClient = ApiClient(
      baseUrl: 'https://api.example.test',
      client: MockClient((request) async => http.Response('Expired', 401)),
    );
    final authState = AuthState(apiClient, initialToken: 'expired-token');
    addTearDown(apiClient.close);
    addTearDown(authState.dispose);

    await expectLater(authState.logout(), throwsA(isA<ApiException>()));
    expect(authState.isLoggedIn, isFalse);
    expect(authState.token, isNull);
  });
}
