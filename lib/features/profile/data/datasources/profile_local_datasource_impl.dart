import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:look4me/modules/auth/models/user_model.dart';
import 'profile_local_datasource.dart';

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String USER_PROFILE_KEY = 'cached_user_profile';

  ProfileLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<UserModel?> getLastUserProfile() async {
    try {
      final jsonString = sharedPreferences.getString(USER_PROFILE_KEY);

      if (jsonString == null || jsonString.isEmpty) {
        return null;
      }

      final userJson = jsonDecode(jsonString);
      return _userModelFromJson(userJson);
    } catch (e) {
      print('Erro ao recuperar perfil do cache: $e');
      return null;
    }
  }

  @override
  Future<void> cacheUserProfile(UserModel user) async {
    try {
      final userJson = _userModelToJson(user);
      await sharedPreferences.setString(
        USER_PROFILE_KEY,
        jsonEncode(userJson),
      );
    } catch (e) {
      print('Erro ao salvar perfil no cache: $e');
    }
  }

  // Converte um UserModel para Map (JSON)
  Map<String, dynamic> _userModelToJson(UserModel user) {
    return {
      'id': user.id,
      'email': user.email,
      'username': user.username,
      'fullName': user.fullName,
      'photoUrl': user.photoUrl,
      'bio': user.bio,
      'createdAt': user.createdAt.millisecondsSinceEpoch,
      'isEmailVerified': user.isEmailVerified,
      'isPrivateProfile': user.isPrivateProfile,
      'blockedUsers': user.blockedUsers,
      'invitedBy': user.invitedBy,
      'availableInvites': user.availableInvites,
      'postCount': user.postCount,
      'followersCount': user.followersCount,
      'followingCount': user.followingCount,
      'likesReceived': user.likesReceived,
      'interests': user.interests,
      'categories': user.categories,
      'fashionStyle': user.fashionStyle,
      'badges': user.badges,
      'reputationPoints': user.reputationPoints,
      'currentBadge': user.currentBadge,
      'receiveVoteNotifications': user.receiveVoteNotifications,
      'receiveFollowerNotifications': user.receiveFollowerNotifications,
      'location': user.location,
      'language': user.language,
      'authProvider': user.authProvider,
    };
  }

  // Converte um Map (JSON) para UserModel
  UserModel _userModelFromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      fullName: json['fullName'],
      photoUrl: json['photoUrl'],
      bio: json['bio'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      isEmailVerified: json['isEmailVerified'] ?? false,
      isPrivateProfile: json['isPrivateProfile'] ?? false,
      blockedUsers: List<String>.from(json['blockedUsers'] ?? []),
      invitedBy: json['invitedBy'],
      availableInvites: json['availableInvites'] ?? 0,
      postCount: json['postCount'] ?? 0,
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      likesReceived: json['likesReceived'] ?? 0,
      interests: List<String>.from(json['interests'] ?? []),
      categories: List<String>.from(json['categories'] ?? []),
      fashionStyle: json['fashionStyle'],
      badges: List<String>.from(json['badges'] ?? []),
      reputationPoints: json['reputationPoints'] ?? 0,
      currentBadge: json['currentBadge'],
      receiveVoteNotifications: json['receiveVoteNotifications'] ?? true,
      receiveFollowerNotifications: json['receiveFollowerNotifications'] ?? true,
      location: json['location'],
      language: json['language'],
      authProvider: json['authProvider'] ?? 'email',
    );
  }
}
