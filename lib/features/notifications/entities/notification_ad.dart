enum AdType {
  banner,
  post,
  popup;

  static AdType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'banner':
        return AdType.banner;
      case 'post':
        return AdType.post;
      case 'popup':
        return AdType.popup;
      default:
        throw ArgumentError('Invalid AdType value');
    }
  }

  bool get isBanner => this == AdType.banner;
  bool get isPost => this == AdType.post;
  bool get isPopup => this == AdType.popup;
}

class NotificationAd {
  final int id;
  final String? content;
  final String? title;
  final AdType type;
  final String? beginAt;
  final String? endAt;
  final String? imageUrl;
  final String? targetUrl;
  final bool isActive;
  final int priority;
  final String createdAt;
  final String updatedAt;
  // custom fields
  final bool seen;

  NotificationAd({
    required this.id,
    required this.content,
    required this.title,
    required this.type,
    required this.beginAt,
    required this.createdAt,
    required this.endAt,
    required this.imageUrl,
    required this.isActive,
    required this.priority,
    required this.targetUrl,
    required this.updatedAt,
    this.seen = false,
  });

  factory NotificationAd.fromJson(Map<String, dynamic> json) {
    return NotificationAd(
      id: json['id'],
      content: json['ad_content'],
      title: json['ad_title'],
      type: AdType.fromString(json['ad_type']),
      beginAt: json['begin_at'],
      createdAt: json['created_at'],
      endAt: json['end_at'],
      imageUrl: json['image_url'],
      isActive: json['is_active'],
      priority: json['priority'],
      targetUrl: json['target_url'],
      updatedAt: json['updated_at'],
    );
  }

  bool get isBanner => type == AdType.banner;
  bool get isPost => type == AdType.post;
  bool get isPopup => type == AdType.popup;

  NotificationAd withSeen(bool seen) {
    return NotificationAd(
      id: id,
      content: content,
      title: title,
      type: type,
      beginAt: beginAt,
      createdAt: createdAt,
      endAt: endAt,
      imageUrl: imageUrl,
      isActive: isActive,
      priority: priority,
      targetUrl: targetUrl,
      updatedAt: updatedAt,
      seen: seen,
    );
  }
}
