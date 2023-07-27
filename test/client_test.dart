import 'package:test/test.dart';
import 'package:unsplash_client/unsplash_client.dart';

void main() {
  test('executing requests after client has been closed should throw', () async {
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

  test('standard client functions work without app credentials as expected', () {
    final clientWithSettings = UnsplashClient(
      settings: const ClientSettings(
        credentials: AppCredentials(
          secretKey: '1234',
          accessKey: '5678',
        ),
      ),
    );

    final clientWithoutSettings = UnsplashClient(
      settings: const ClientSettings(),
    );

    expect(clientWithSettings.settings == clientWithSettings.settings, true);
    expect(clientWithSettings.settings == clientWithoutSettings.settings, false);
    expect(clientWithoutSettings.settings == clientWithSettings.settings, false);
    expect(clientWithoutSettings.settings == clientWithoutSettings.settings, true);

    var clientWithSettingsHashCode = clientWithSettings.settings.hashCode;
    expect(clientWithSettingsHashCode == 1043090474, true);

    var clientWithoutSettingsHashCode = clientWithoutSettings.settings.hashCode;
    expect(clientWithoutSettingsHashCode == 346277, true);

    var clientWithSettingsString = clientWithSettings.settings.toString();
    expect(
        clientWithSettingsString ==
            'ClientSettings{credentials: Credentials{accessKey: 5678, '
                'secretKey: HIDDEN}, '
                'maxPageSize: 30}',
        true);

    var clientWithoutSettingsString = clientWithoutSettings.settings.toString();
    expect(
        clientWithoutSettingsString ==
            'ClientSettings{credentials: null, '
                'maxPageSize: 30}',
        true);
  });
}
