An unofficial client to for the [unsplash](https://unsplash.com) api.

The client is platform independent, since it uses [http](https://pub.dev/packages/http) to make
requests.

This is a work in progress:
 
 - [ ] Get the user’s profile
 - [ ] Update the current user’s profile
 
 - [x] Get a user’s public profile
 - [x] Get a user’s portfolio link
 - [x] List a user’s photos
 - [x] List a user’s liked photos
 - [x] List a user’s collections
 - [x] Get a user’s statistics
 
 - [x] List photos 
 - [x] Get a photo
 - [x] Get random photos
 - [x] Get a photo’s statistics
 - [x] Track a photo download
 - [ ] Update a photo
 - [ ] Like a photo
 - [ ] Unlike a photo
 
 - [ ] Search photos
 - [ ] Search collections
 - [ ] Search users
 
 - [ ] List collections
 - [ ] List featured collections
 - [ ] Get a collection
 - [ ] Get a collection’s photos
 - [ ] List a collection’s related collections
 - [ ] Create a new collection
 - [ ] Update an existing collection
 - [ ] Delete a collection
 - [ ] Add a photo to a collection
 - [ ] Remove a photo from a collection
 
 - [x] Stats.total
 - [x] Stats.month


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
