class Photo {
  final String thumbnailUrl;

  Photo({this.thumbnailUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return new Photo(
      thumbnailUrl: json['urldata'] as String,
    );
  }
}