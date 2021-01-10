[![](https://badgen.net/pub/v/unsplash_client)](https://pub.dev/packages/unsplash_client)
[![](https://badgen.net/pub/license/unsplash_client)](./LICENSE)
![](https://badgen.net/pub/dart-platform/unsplash_client)
![](https://badgen.net/pub/flutter-platform/unsplash_client)

# unsplash_client

An unofficial client for the [unsplash](https://unsplash.com) api.

The client is platform independent, since it uses [http](https://pub.dev/packages/http) to make
requests.

## Setup

1. You need to [register](https://unsplash.com/developers) as a developer and create an unsplash app to access the API.

1. Obtain the credentials for your app from the developer portal and create an `UnsplashClient`:

```dart
final client = UnsplashClient(
  settings: ClientSettings(credentials: AppCredentials(
    accessKey: '...',
    secretKey: '...',
  )),
);
```

## Usage

### Get a random photo

```dart
// Make the request.
final response = await client.photos.random(count: 1).go();

// Check that the request was successful.
if (!response.isOk) {
  throw 'Something is wrong: $response';
}

// The api returns a `Photo` which contains metadata about the photo and urls to download it.
final photo = response.data.first;
```

### Photo variants 

A `Photo` comes with a set of urls for variants of the photo of different sizes, such as `regular` and `thumb`:

```dart
final thumb = photo.urls.thumb;
```

If the provided variants are not a good fit for your use, you can generate urls where you specify size, quality,
fit and other parameters.

Call the extension method `Uri.resizePhoto` on `photo.urls.raw` to generate an `Uri` for a custom variant:

```dart
final custom = photo.urls.raw.resizePhoto(width: 400, height: 400);
```

## Example

See [examples tab](https://pub.dev/packages/unsplash_client/example) for a runnable example.

## TODO

- [ ] Get the user’s profile
- [ ] Update the current user’s profile
- [ ] Update a photo
- [ ] Like a photo
- [ ] Unlike a photo
- [ ] Create a new collection
- [ ] Update an existing collection
- [ ] Delete a collection
- [ ] Add a photo to a collection
- [ ] Remove a photo from a collection
