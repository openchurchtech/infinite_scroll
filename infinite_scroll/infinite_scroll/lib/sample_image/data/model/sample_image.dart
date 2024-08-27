class SampleImage {
  final String id;
  final String author;
  final int width;
  final int height;
  final String url;
  final String downloadUrl;

  SampleImage({
    required this.id,
    required this.author,
    required this.width,
    required this.height,
    required this.url,
    required this.downloadUrl,
  });

  factory SampleImage.fromJson(Map<String, dynamic> json) {
    return SampleImage(
      id: json['id'] as String,
      author: json['author'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      url: json['url'] as String,
      downloadUrl: json['download_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'width': width,
      'height': height,
      'url': url,
      'download_url': downloadUrl,
    };
  }

  static List<SampleImage> listFromJson(List<dynamic> jsonList) {
    return jsonList
        .map((json) => SampleImage.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static List<dynamic> listToJson(List<SampleImage> images) {
    return images.map((image) => image.toJson()).toList();
  }
}
