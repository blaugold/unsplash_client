An unofficial client to for the [unsplash](https://unsplash.com) api.

The client is platform independent, since it uses [http](https://pub.dev/packages/http) to make
requests.

This is a work in progress. The following endpoints are implemented:
 - Photos.list 
 - Photos.random
 - Stats.total
 - Stats.month

## Usage

A simple usage example:

```dart
import 'package:unsplash_client/unsplash_client.dart';

void main() async {
  // Create a client.
  final client = UnsplashClient(
    settings: Settings(
      // Use the credentials from the developer portal.
      credentials: AppCredentials(
        accessKey: '...',
        secretKey: '...',
      )     
    ),
  );
  
  // Fetch 5 random photos.
  final response = await client.photos.random(count: 5).go();
  
  // Check that the request was successful.
  if (!response.isOk) {
    throw 'Something is wrong: $response';
  }
  
  // Do something with the photos.
  final photos = response.data;
  
  // Create a dynamically resizing url.
  final resizedUrl = photos.first.urls.raw.resize(
    width: 400,
    height: 400,
    fit: ResizeFitMode.cover,
    format: ImageFormat.webp,
  );

}
```
