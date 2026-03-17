class ActivityModel {
  final String id;
  final String title;
  final String description;
  final String location;
  final String startTime;
  final String endTime;
  final int maxParticipants;
  final int currentParticipants;
  final String organizer;
  final String status; // upcoming, ongoing, ended
  final String coverImage;
  final List<String> tags;

  const ActivityModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startTime,
    required this.endTime,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.organizer,
    required this.status,
    required this.coverImage,
    required this.tags,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      maxParticipants: json['maxParticipants'] ?? 0,
      currentParticipants: json['currentParticipants'] ?? 0,
      organizer: json['organizer'] ?? '',
      status: json['status'] ?? 'upcoming',
      coverImage: json['coverImage'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  bool get isFull => currentParticipants >= maxParticipants;
  double get fillRate =>
      maxParticipants > 0 ? currentParticipants / maxParticipants : 0;

  String get statusLabel {
    switch (status) {
      case 'upcoming':
        return '即将开始';
      case 'ongoing':
        return '进行中';
      case 'ended':
        return '已结束';
      default:
        return '未知';
    }
  }
}

class KnowledgeModel {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String author;
  final String authorAvatar;
  final String publishTime;
  final int viewCount;
  final int likeCount;
  final List<String> tags;
  final String category;
  final String coverImage;

  const KnowledgeModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.author,
    required this.authorAvatar,
    required this.publishTime,
    required this.viewCount,
    required this.likeCount,
    required this.tags,
    required this.category,
    required this.coverImage,
  });

  factory KnowledgeModel.fromJson(Map<String, dynamic> json) {
    return KnowledgeModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      author: json['author'] ?? '',
      authorAvatar: json['authorAvatar'] ?? '',
      publishTime: json['publishTime'] ?? '',
      viewCount: json['viewCount'] ?? 0,
      likeCount: json['likeCount'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      category: json['category'] ?? '技术',
      coverImage: json['coverImage'] ?? '',
    );
  }
}

class UserModel {
  final String openid;
  final String nickname;
  final String avatar;
  final String phone;
  final List<String> registeredActivities;
  final List<String> publishedKnowledge;

  const UserModel({
    required this.openid,
    required this.nickname,
    required this.avatar,
    this.phone = '',
    this.registeredActivities = const [],
    this.publishedKnowledge = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      openid: json['openid'] ?? '',
      nickname: json['nickname'] ?? '用户',
      avatar: json['avatar'] ?? '',
      phone: json['phone'] ?? '',
      registeredActivities:
          List<String>.from(json['registeredActivities'] ?? []),
      publishedKnowledge: List<String>.from(json['publishedKnowledge'] ?? []),
    );
  }
}
