[![pub.dev package page](https://badgen.net/pub/v/unsplash_client)](https://pub.dev/packages/unsplash_client)
[![GitHub Actions CI](https://github.com/blaugold/unsplash_client/actions/workflows/ci.yml/badge.svg)](https://github.com/blaugold/unsplash_client/actions/workflows/ci.yml)
[![GitHub Stars](https://badgen.net/github/stars/blaugold/unsplash_client)](https://github.com/blaugold/unsplash_client/stargazers)

[Unsplash][unsplash] provides free high-resolution photos. This is a client for
their [REST API][unsplash api].

---

If you're looking for a **database solution**, check out
[`cbl`](https://pub.dev/packages/cbl), another project of mine. It brings
Couchbase Lite to **standalone Dart** and **Flutter**, with support for:

- **Full-Text Search**,
- **Expressive Queries**,
- **Data Sync**,
- **Change Notifications**

and more.

---

# Limitations

Endpoints that act on behalf of a user are not implemented, yet.If that is
something you need, please comment on
[this issue](https://github.com/blaugold/unsplash_client/issues/5).

# Requirements

You need to [register as a developer][unsplash developer portal] and create an
Unsplash app to access the API.

# Getting started

## Create an `UnsplashClient`

Use the credentials for your app, obtained from the developer portal, to create
an `UnsplashClient`:

```dart
final client = UnsplashClient(
  settings: ClientSettings(credentials: AppCredentials(
    accessKey: '...',
    secretKey: '...',
  )),
);
```

> :warning: When you are done using a client instance, make sure to call it's
> `close` method.

### Moving authentication to an authentication proxy

If you would like to use an authentication proxy and want to change the URL of the 
Unsplash API endpoint you can use the following code:

```dart
final client = UnsplashClient(
  settings: const ClientSettings()),
  proxyBaseUrl: Uri.parse('YOUR_PROXY_URL'));
);
```
You can omit the `credentials` parameter and provide your own endpoint by 
using the `proxyBaseUrl` parameter.

## Get a random photo

```dart
// Call `goAndGet` to execute the [Request] returned from `random`
// and throw an exception if the [Response] is not ok.
final photos = await client.photos.random(count: 1).goAndGet();

// The api returns a `Photo` which contains metadata about the photo and urls to download it.
final photo = photos.first;
```

## Photo variants

A `Photo` comes with a set of urls for variants of the photo of different sizes,
such as `regular` and `thumb`:

```dart
final thumb = photo.urls.thumb;
```

If the provided variants are not a good fit for your use, you can generate urls
where you specify size, quality, fit and other parameters.

Call the extension method `Uri.resizePhoto` on `photo.urls.raw` to generate an
`Uri` for a custom variant:

```dart
final custom = photo.urls.raw.resizePhoto(width: 400, height: 400);
```

# Example

The [example](https://pub.dev/packages/unsplash_client/example) is a simple CLI
app that fetches a few random photos.

---

**Gabriel Terwesten** &bullet; **GitHub**
**[@blaugold](https://github.com/blaugold)** &bullet; **Twitter**
**[@GTerwesten](https://twitter.com/GTerwesten)** &bullet; **Medium**
**[@gabriel.terwesten](https://medium.com/@gabriel.terwesten)**

[unsplash api]: https://unsplash.com/documentation
[unsplash]: https://unsplash.com/
[unsplash developer portal]: https://unsplash.com/developers
