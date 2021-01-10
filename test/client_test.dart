import 'package:test/test.dart';
import 'package:unsplash_client/unsplash_client.dart';

void main() {
  test('executing requests after client has been closed should throw',
      () async {
    final client = UnsplashClient(
      settings: ClientSettings(
        credentials: AppCredentials(
          secretKey: '',
          accessKey: '',
        ),
      ),
    );

    client.close();

    final req = client.users.get('username');

    expect(req.go, throwsStateError);
  });
}
