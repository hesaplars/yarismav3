class AppUser {
  const AppUser({
    required this.uid,
    required this.name,
    required this.avatar,
    required this.isGuest,
    required this.acceptedTerms,
    this.photoUrl,
  });

  final String uid;
  final String name;
  final String avatar;
  final bool isGuest;
  final bool acceptedTerms;
  final String? photoUrl;

  bool get hasAccess => acceptedTerms && name.trim().isNotEmpty;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: '${json['uid'] ?? ''}',
      name: '${json['name'] ?? ''}',
      avatar: '${json['avatar'] ?? '🍄'}',
      isGuest: json['isGuest'] == true,
      acceptedTerms: json['acceptedTerms'] == true,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'avatar': avatar,
      'isGuest': isGuest,
      'acceptedTerms': acceptedTerms,
      'photoUrl': photoUrl,
    };
  }
}
