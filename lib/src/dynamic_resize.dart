import 'utils.dart';

// ignore_for_file: public_member_api_docs

/// The output format to convert the image to.
///
/// See: [Imgix docs](https://docs.imgix.com/apis/url/format/fm)
enum ImageFormat {
  gif,
  jp2,
  jpg,
  json,
  jxr,
  pjpg,
  mp4,
  png,
  png8,
  png32,
  webm,
  webp,
}

/// Controls how the output image is fit to its target dimensions after
/// resizing, and how any background areas will be filled.
///
/// See: [Imgix docs](https://docs.imgix.com/apis/url/size/fit)
enum ResizeFitMode {
  clamp,
  clip,
  crop,
  facearea,
  fill,
  fillmax,
  max,
  min,
  scale,
}

/// Returns a new [Uri], Based on [photoUrl], under which a dynamically
/// resized version of the original photo can be accessed.
///
/// {@macro unsplash.client.photo.resize}
///
// TODO: auto=format: for automatically choosing the optimal image format
// depending on user browser
Uri resizePhotoUrl(
  Uri photoUrl, {
  int? quality,
  int? width,
  int? height,
  int? devicePixelRatio,
  ImageFormat? format,
  ResizeFitMode? fit,
  Map<String, String>? imgixParams,
}) {
  assert(quality.isNull || quality! >= 0 && quality <= 100);
  assert(width.isNull || width! >= 0);
  assert(height.isNull || height! >= 0);
  assert(devicePixelRatio.isNull ||
      devicePixelRatio! >= 0 && devicePixelRatio <= 8);

  // The officially supported params.
  final params = {
    'q': quality?.toString(),
    'w': width?.toString(),
    'h': height?.toString(),
    'dpi': devicePixelRatio?.toString(),
    'fit': fit?.let(enumName),
    'fm': format?.let(enumName),
  };

  if (imgixParams != null) {
    params.addAll(imgixParams);
  }

  // Make sure the original query parameters are included for view tracking,
  // as required by unsplash.
  params.addAll(photoUrl.queryParameters);

  // Remove params whose value is null.
  params.removeWhereValue(isNull);

  return photoUrl.replace(queryParameters: params);
}

/// Creates photo urls which dynamically resize the original image.
extension DynamicResizeUrl on Uri {
  /// Returns a new [Uri], Based on this photo url, under which a dynamically
  /// resized version of the original photo can be accessed.
  ///
  /// {@template unsplash.client.photo.resize}
  /// Unsplash supports dynamic resizing of photos. The transformations applied
  /// to the original photo can be configured through a set of query parameters
  /// in the requested url.
  ///
  /// The officially supported parameters are:
  ///
  /// - [width], [height] : for adjusting the width and height of a photo
  /// - [crop] : for applying cropping to the photo
  /// - [format] : for converting image format
  /// - [quality] : for changing the compression quality when using lossy file
  /// formats
  /// - [fit] : for changing the fit of the image within the specified
  /// dimensions
  /// - [devicePixelRatio] : for adjusting the device pixel ratio of the image
  ///
  /// Under the hood unsplash uses [imgix](https://www.imgix.com/). The
  /// [other parameters](https://docs.imgix.com/apis/url) offered by Imgix can be
  /// used through [imgixParams], but unsplash dose not officially support them
  /// and may remove support for them at any time in the future.
  ///
  /// See: [Unsplash docs](https://unsplash.com/documentation#supported-parameters)
  /// {@endtemplate}
  Uri resizePhoto({
    int? quality,
    int? width,
    int? height,
    int? devicePixelRatio,
    ImageFormat? format,
    ResizeFitMode? fit,
    Map<String, String>? imgixParams,
  }) =>
      resizePhotoUrl(
        this,
        quality: quality,
        width: width,
        height: height,
        devicePixelRatio: devicePixelRatio,
        format: format,
        fit: fit,
        imgixParams: imgixParams,
      );
}
