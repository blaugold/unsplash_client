import 'package:test/test.dart';
import 'package:unsplash_client/unsplash_client.dart';

void main() {
  test('executing requests after client has been closed should throw', () async {
    final client = UnsplashClient(
      settings: ClientSettings(
        unsplashCredentials: AppCredentials(
          secretKey: '',
          accessKey: '',
        ),
      ),
    );

    client.close();

    final req = client.users.get('username');

    expect(req.go, throwsStateError);
  });

  test('standard client functions work without app credentials as expected', () {
    final clientWithUnsplashCredentials = UnsplashClient(
      settings: const ClientSettings(
        unsplashCredentials: AppCredentials(
          secretKey: '1234',
          accessKey: '5678',
        ),
      ),
    );

    final clientWithoutUnsplashCredentials = UnsplashClient(
      settings: const ClientSettings(bearerToken: '1234'),
    );

    expect(clientWithUnsplashCredentials.settings == clientWithUnsplashCredentials.settings, true);
    expect(clientWithUnsplashCredentials.settings == clientWithoutUnsplashCredentials.settings, false);
    expect(clientWithoutUnsplashCredentials.settings == clientWithUnsplashCredentials.settings, false);
    expect(clientWithoutUnsplashCredentials.settings == clientWithoutUnsplashCredentials.settings, true);

    var clientWithSettingsHashCode = clientWithUnsplashCredentials.settings.hashCode;
    expect(clientWithSettingsHashCode == 1043090417, true);

    var clientWithoutUnsplashCredentialsHashCode = clientWithoutUnsplashCredentials.settings.hashCode;
    expect(clientWithoutUnsplashCredentialsHashCode == 759431771, true);

    var clientWithUnsplashCredentialsString = clientWithUnsplashCredentials.settings.toString();
    expect(
        clientWithUnsplashCredentialsString ==
            'ClientSettings{credentials: Credentials{accessKey: 5678, '
                'secretKey: HIDDEN}, '
                'bearerToken: null, '
                'maxPageSize: 30}',
        true);

    var clientWithoutUnsplashCredentialsString = clientWithoutUnsplashCredentials.settings.toString();
    expect(
        clientWithoutUnsplashCredentialsString ==
            'ClientSettings{credentials: null, '
                'bearerToken: 1234, '
                'maxPageSize: 30}',
        true);
  });
}
