import 'package:infinite_scroll/sample_image/data/caching/cache_manager.dart';
import 'package:rxdart/rxdart.dart';
import '../data/model/sample_image.dart';
import '../data/repository/sample_image_repository.dart';

class ImageController {
  final SampleImageRepository _repository = SampleImageRepository();
  final CacheManager _cacheManager = CacheManager();
  final _imagesSubject = BehaviorSubject<List<SampleImage>>.seeded([]);
  final _loadingSubject = BehaviorSubject<bool>.seeded(false);
  final _hasMoreSubject = BehaviorSubject<bool>.seeded(true);
  int _currentPage = 0;
  final int _limit = 20;

  // Streams
  Stream<List<SampleImage>> get imagesStream => _imagesSubject.stream;
  Stream<bool> get loadingStream => _loadingSubject.stream;
  Stream<bool> get hasMoreStream => _hasMoreSubject.stream;

  CacheManager getCacheManager() {
    return _cacheManager;
  }

  void fetchImages({required int limit}) async {
    if (_loadingSubject.value) return;

    _loadingSubject.add(true);
    try {
      _currentPage++;
      final images =
          await _repository.fetchImages(page: _currentPage, limit: _limit);
      final currentImages = _imagesSubject.value;

      if (images.isEmpty) {
        _hasMoreSubject.add(false);
      } else {
        _imagesSubject.add(currentImages + images);
        await _cacheManager.saveImages(currentImages + images);
      }
    } catch (e) {
      // Handle errors
    } finally {
      _loadingSubject.add(false);
    }
  }

  void dispose() {
    _imagesSubject.close();
    _loadingSubject.close();
    _hasMoreSubject.close();
  }
}
