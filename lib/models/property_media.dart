import 'dart:convert';

class PropertyMedia {
  String? mediaType;
  String? url;
  String? thumbnail;
  PropertyMedia({
    this.mediaType,
    this.url,
    this.thumbnail,
  });

  PropertyMedia copyWith({
    String? mediaType,
    String? url,
    String? thumbnail,
  }) {
    return PropertyMedia(
      mediaType: mediaType ?? this.mediaType,
      url: url ?? this.url,
      thumbnail: thumbnail ?? this.thumbnail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mediaType': mediaType,
      'url': url,
      'thumbnail': thumbnail,
    };
  }

  factory PropertyMedia.fromMap(Map<String, dynamic> map) {
    return PropertyMedia(
      mediaType: map['mediaType'],
      url: map['url'],
      thumbnail: map['thumbnail'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PropertyMedia.fromJson(String source) => PropertyMedia.fromMap(json.decode(source));

  @override
  String toString() => 'PropertyMedia(mediaType: $mediaType, url: $url, thumbnail: $thumbnail)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is PropertyMedia &&
      other.mediaType == mediaType &&
      other.url == url &&
      other.thumbnail == thumbnail;
  }

  @override
  int get hashCode => mediaType.hashCode ^ url.hashCode ^ thumbnail.hashCode;
}
