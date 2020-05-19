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
