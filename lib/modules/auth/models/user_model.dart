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
  final bool isEmailVerified;

  // Perfil e Privacidade
  final bool isPrivateProfile;
  final List<String> blockedUsers;

  // Sistema de convites
  final String? invitedBy; // ID do convite usado no cadastro
  final int availableInvites; // Número de convites disponíveis para enviar

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

  // Tipo de autenticação
  final String authProvider; // 'email', 'google', 'apple'

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    this.photoUrl,
    this.bio,
    required this.createdAt,
    this.isEmailVerified = false,
    this.isPrivateProfile = false,
    this.blockedUsers = const [],
    this.invitedBy,
    this.availableInvites = 0,
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
    this.authProvider = 'email',
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
      isEmailVerified: data['isEmailVerified'] ?? false,
      isPrivateProfile: data['isPrivateProfile'] ?? false,
      blockedUsers: List<String>.from(data['blockedUsers'] ?? []),
      invitedBy: data['invitedBy'],
      availableInvites: data['availableInvites'] ?? 0,
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
      authProvider: data['authProvider'] ?? 'email',
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
      'isEmailVerified': isEmailVerified,
      'isPrivateProfile': isPrivateProfile,
      'blockedUsers': blockedUsers,
      'invitedBy': invitedBy,
      'availableInvites': availableInvites,
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
      'authProvider': authProvider,
    };
  }

  UserModel copyWith({
    String? email,
    String? username,
    String? fullName,
    String? photoUrl,
    String? bio,
    bool? isEmailVerified,
    bool? isPrivateProfile,
    List<String>? blockedUsers,
    String? invitedBy,
    int? availableInvites,
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
    String? authProvider,
  }) {
    return UserModel(
      id: id,
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      createdAt: createdAt,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isPrivateProfile: isPrivateProfile ?? this.isPrivateProfile,
      blockedUsers: blockedUsers ?? this.blockedUsers,
      invitedBy: invitedBy ?? this.invitedBy,
      availableInvites: availableInvites ?? this.availableInvites,
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
      authProvider: authProvider ?? this.authProvider,
    );
  }

  @override
  List<Object?> get props => [
    id, email, username, fullName, photoUrl, bio,
    createdAt, isEmailVerified, isPrivateProfile, blockedUsers,
    invitedBy, availableInvites,
    postCount, followersCount, followingCount, likesReceived,
    interests, categories, fashionStyle,
    badges, reputationPoints, currentBadge,
    receiveVoteNotifications, receiveFollowerNotifications,
    location, language, authProvider
  ];
}
