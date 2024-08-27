import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll/sample_image/controller/sample_image_controller.dart';
import 'package:infinite_scroll/sample_image/data/model/sample_image.dart';
import 'package:infinite_scroll/sample_image/view/image_frame.dart';

class ImageListingScreen extends StatefulWidget {
  const ImageListingScreen({super.key});

  @override
  _ImageListingScreenState createState() => _ImageListingScreenState();
}

class _ImageListingScreenState extends State<ImageListingScreen> {
  late final ImageController _imageController;
  bool _isLoading = true;
  bool _hasConnectivity = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _imageController = ImageController();
    _checkConnectivity();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _imageController.fetchImages();
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
      _imageController.fetchImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instagram-Like Gallery'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasConnectivity
              ? StreamBuilder<List<SampleImage>>(
                  stream: _imageController.imagesStream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No images found.'));
                    }

                    final images = snapshot.data ?? [];
                    return NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        // Fetch more images when reaching the end
                        // if (!_imageController.loadingStream.value &&
                        //     _imageController.hasMoreStream.value &&
                        //     scrollInfo.metrics.pixels ==
                        //         scrollInfo.metrics.maxScrollExtent) {
                        _imageController.fetchImages();
                        // }
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
                          return
                              // Image.network(
                              //   image.url,
                              //   fit: BoxFit.cover,
                              //   errorBuilder: (context, error, stackTrace) =>
                              //       Center(
                              //     child: Icon(Icons.error, color: Colors.red),
                              //   ),
                              // );
                              ImageFrame(
                            snap: image,
                          );
                        },
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text(
                      'No internet connection. Please check your network settings.')),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _imageController.dispose();
    super.dispose();
  }
}
