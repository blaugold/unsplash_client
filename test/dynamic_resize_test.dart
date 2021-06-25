import 'package:test/test.dart';
import 'package:unsplash_client/unsplash_client.dart';

void main() {
  test('adds query parameters for non null options', () {
    final uri = Uri.parse('http://origin/path?a=b');
    final newUri = uri.resizePhoto(
      quality: 1,
      width: 2,
      height: 3,
      crop: CropMode.top,
      fit: ResizeFitMode.crop,
      format: ImageFormat.jpg,
      autoFormat: true,
      devicePixelRatio: 4,
      imgixParams: {'c': 'd'},
    );
    expect(
      newUri.toString(),
      'http://origin/path?q=1&w=2&h=3&crop=top&dpi=4&fm=jpg&auto=format&fit=crop&c=d&a=b',
    );
  });

  test('returns equivalent URI when all options are null', () {
    final uri = Uri.parse('http://origin/path?a=b');
    final newUri = uri.resizePhoto();
    expect(newUri.toString(), 'http://origin/path?a=b');
  });

  test('adds imgix parameters as given', () {
    final uri = Uri.parse('http://origin/path?a=b');
    final newUri = uri.resizePhoto(imgixParams: {'c': 'd'});
    expect(newUri.toString(), 'http://origin/path?c=d&a=b');
  });

  test('keeps existing query parameters', () {
    final uri = Uri.parse('http://origin/path?a=b');
    final newUri = uri.resizePhoto(quality: 50);
    expect(newUri.toString(), 'http://origin/path?q=50&a=b');
  });
}
