import 'package:flutter/material.dart';
import 'package:infinite_scroll/sample_image/view/image_listing_screen.dart';

void main() {
  runApp(const InfiniteScroll());
}

class InfiniteScroll extends StatelessWidget {
  const InfiniteScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageListingScreen(),
    );
  }
}
