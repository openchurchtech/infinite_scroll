import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll/sample_image/controller/sample_image_controller.dart';
import 'package:infinite_scroll/sample_image/data/caching/cache_manager.dart';
import 'package:infinite_scroll/sample_image/data/model/sample_image.dart';
import 'package:infinite_scroll/sample_image/view/image_frame.dart';
import 'package:infinite_scroll/widgets/filter_dialog.dart';

class ImageListingScreen extends StatefulWidget {
  const ImageListingScreen({super.key});

  @override
  _ImageListingScreenState createState() => _ImageListingScreenState();
}

class _ImageListingScreenState extends State<ImageListingScreen> {
  late final ImageController _imageController;
  late CacheManager _cacheManager;
  bool _isLoading = true;
  bool _hasConnectivity = false;
  int _imagesPerPage = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _imageController = ImageController();
    _cacheManager = _imageController.getCacheManager();
    _checkConnectivity();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _imageController.fetchImages(limit: _imagesPerPage);
      }
    });
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      _hasConnectivity = connectivityResult != ConnectivityResult.none;
      _isLoading = false;
    });

    if (_hasConnectivity) {
      _imageController.fetchImages(limit: _imagesPerPage);
    }
  }

  void _showFiltersDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FiltersDialog(
          onImagesPerPageChanged: (newLimit) {
            setState(() {
              _imagesPerPage = newLimit;
            });
            _imageController.fetchImages(limit: _imagesPerPage);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram-Like Gallery'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.filter_list),
        //     onPressed: _showFiltersDialog,
        //   ),
        // ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<List<SampleImage>>(
              stream: _hasConnectivity
                  ? _imageController.imagesStream
                  : _cacheManager.loadImages().asStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No images found.'));
                }

                final images = snapshot.data ?? [];
                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollInfo) {
                    _imageController.fetchImages(limit: _imagesPerPage);
                    return false;
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: images.length + 1,
                    itemBuilder: (context, index) {
                      if (index == images.length) {
                        return StreamBuilder<bool>(
                          stream: _imageController.loadingStream,
                          builder: (context, loadingSnapshot) {
                            if (loadingSnapshot.data == true) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        );
                      }

                      final image = images[index];
                      return ImageFrame(
                        snap: image,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _imageController.dispose();
    super.dispose();
  }
}
