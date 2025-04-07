import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String username;
  final String fullName;
  final String? photoUrl;
  final String? bio;
  final DateTime createdAt;

  // Perfil e Privacidade
  final bool isPrivateProfile;
  final List<String> blockedUsers;

  // Estatísticas de Interação
  final int postCount;
  final int followersCount;
  final int followingCount;
  final int likesReceived;

  // Preferências e Interesses
  final List<String> interests;
  final List<String> categories;
  final String? fashionStyle;

  // Badges e Reputação
  final List<String> badges;
  final int reputationPoints;
  final String? currentBadge;

  // Configurações de Notificação
  final bool receiveVoteNotifications;
  final bool receiveFollowerNotifications;

  // Localização e Contexto
  final String? location;
  final String? language;

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    this.photoUrl,
    this.bio,
    required this.createdAt,
    this.isPrivateProfile = false,
    this.blockedUsers = const [],
    this.postCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.likesReceived = 0,
    this.interests = const [],
    this.categories = const [],
    this.fashionStyle,
    this.badges = const [],
    this.reputationPoints = 0,
    this.currentBadge,
    this.receiveVoteNotifications = true,
    this.receiveFollowerNotifications = true,
    this.location,
    this.language,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      fullName: data['fullName'] ?? '',
      photoUrl: data['photoUrl'],
      bio: data['bio'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isPrivateProfile: data['isPrivateProfile'] ?? false,
      blockedUsers: List<String>.from(data['blockedUsers'] ?? []),
      postCount: data['postCount'] ?? 0,
      followersCount: data['followersCount'] ?? 0,
      followingCount: data['followingCount'] ?? 0,
      likesReceived: data['likesReceived'] ?? 0,
      interests: List<String>.from(data['interests'] ?? []),
      categories: List<String>.from(data['categories'] ?? []),
      fashionStyle: data['fashionStyle'],
      badges: List<String>.from(data['badges'] ?? []),
      reputationPoints: data['reputationPoints'] ?? 0,
      currentBadge: data['currentBadge'],
      receiveVoteNotifications: data['receiveVoteNotifications'] ?? true,
      receiveFollowerNotifications: data['receiveFollowerNotifications'] ?? true,
      location: data['location'],
      language: data['language'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'fullName': fullName,
      'photoUrl': photoUrl,
      'bio': bio,
      'createdAt': createdAt,
      'isPrivateProfile': isPrivateProfile,
      'blockedUsers': blockedUsers,
      'postCount': postCount,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'likesReceived': likesReceived,
      'interests': interests,
      'categories': categories,
      'fashionStyle': fashionStyle,
      'badges': badges,
      'reputationPoints': reputationPoints,
      'currentBadge': currentBadge,
      'receiveVoteNotifications': receiveVoteNotifications,
      'receiveFollowerNotifications': receiveFollowerNotifications,
      'location': location,
      'language': language,
    };
  }

  UserModel copyWith({
    String? email,
    String? username,
    String? fullName,
    String? photoUrl,
    String? bio,
    bool? isPrivateProfile,
    List<String>? blockedUsers,
    int? postCount,
    int? followersCount,
    int? followingCount,
    int? likesReceived,
    List<String>? interests,
    List<String>? categories,
    String? fashionStyle,
    List<String>? badges,
    int? reputationPoints,
    String? currentBadge,
    bool? receiveVoteNotifications,
    bool? receiveFollowerNotifications,
    String? location,
    String? language,
  }) {
    return UserModel(
      id: id,
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt,
      isPrivateProfile: isPrivateProfile ?? this.isPrivateProfile,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      postCount: postCount ?? this.postCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      likesReceived: likesReceived ?? this.likesReceived,
      interests: interests ?? this.interests,
      categories: categories ?? this.categories,
      fashionStyle: fashionStyle ?? this.fashionStyle,
      badges: badges ?? this.badges,
      reputationPoints: reputationPoints ?? this.reputationPoints,
      currentBadge: currentBadge ?? this.currentBadge,
      receiveVoteNotifications: receiveVoteNotifications ?? this.receiveVoteNotifications,
      receiveFollowerNotifications: receiveFollowerNotifications ?? this.receiveFollowerNotifications,
      location: location ?? this.location,
      language: language ?? this.language,
    );
  }

  @override
  List<Object?> get props => [
    id, email, username, fullName, photoUrl, bio,
    createdAt, isPrivateProfile, blockedUsers,
    postCount, followersCount, followingCount, likesReceived,
    interests, categories, fashionStyle,
    badges, reputationPoints, currentBadge,
    receiveVoteNotifications, receiveFollowerNotifications,
    location, language
  ];
}
