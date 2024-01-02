## 2.2.0

- feat: add `Photos.download(location)` (#22)

## 2.1.1

- chore: allow 1.0.0 in version constraint for http (#18)

## 2.1.0+3

- docs: fix formatting

## 2.1.0+2

- docs: add mention of `cbl`

## 2.1.0+1

- docs: rewrite README

## 2.1.0

- feat: log through `logging` package
- feat: add `crop` and `autoFormat` options for image resizing
- feat: add `source` property to models
- docs: add docs for `TopicOrder`

## 2.0.0

- feat: add `Topic` resource
- feat: add `lang` parameter to `Search.photos`
- breaking change: remove `UserStatistics.likes`
- breaking change: make `Photo.blurHash` nullable

## 1.1.0

- feat: add `Photo.blurHash`
- deprecation: `PhotoOrder.popular`
- deprecation: `featured` parameter of `Collections.list`
- deprecation: `UserStatistics.likes`

## 1.0.1+2

- revert to sdk constraint `>=2.12.0-0 <3.0.0`

## 1.0.1+1

- style: fix formatting

## 1.0.1

- fix: fix short-circuiting issue

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
