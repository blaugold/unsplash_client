## 1.0.0

- feat: migrate to null-safety
- fix: fix spelling of `RequestExtension`
- fix: only parse body of success response
- fix: use correct url for `Collections.photos` and `Collections.related`
- docs: use `goAndGet` in docs

## 0.3.0+1

- docs: update description

## 0.3.0

- feat: add `UnsplashClient.close` method
- fix: change type of `Collection.id` to `String` (unsplash API changed)
- build(deps): upgrade dependencies
- docs: improve README
- fix: fix typos

## 0.2.1

- bump dependencies
- move to pedantic code style

## 0.2.0

- feat(): improve client
  - handle non json body
  - add `Response.get` to get `Response.data` or throw an error
- feat(): add various filtering options
  - Photos.random: contentFilter
  - Search.photos: color, orderBy, contentFilter
  - Users.photos: orientation
  - Users.likedPhotos: orientation
  - PhotoOrder.relevant
- feat(): add collections api (public actions only)

- fix(): include User.portfolio in json representation

## 0.1.2

- fix(): downgrade version of collection to ^1.14.11

## 0.1.1

- add runnable example
- update package description

## 0.1.0

- Initial release
