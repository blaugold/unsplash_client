An unofficial client to for the [unsplash](https://unsplash.com) api.

This is a work in progress. At the moment only **Photos.list** and **Photos.random** are
implemented.

## Usage

A simple usage example:

```dart
import 'package:unsplash_client/client.dart';

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
  
  // Create a dynamically resized url.
  final resizedUrl = photos.first.urls.raw.resize(
    width: 400,
    height: 400,
    fit: ResizeFitMode.cover,
    format: ImageFormat.webp,
  );

}
```
