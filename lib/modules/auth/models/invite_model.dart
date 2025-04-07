import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class InviteModel extends Equatable {
  final String id;
  final String createdBy; // ID do usuário que criou o convite
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool isUsed;
  final String? usedByUserId;
  final DateTime? usedAt;

  const InviteModel({
    required this.id,
    required this.createdBy,
    required this.createdAt,
    required this.expiresAt,
    this.isUsed = false,
    this.usedByUserId,
    this.usedAt,
  });

  factory InviteModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return InviteModel(
      id: doc.id,
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate() ?? DateTime.now().add(Duration(days: 7)),
      isUsed: data['isUsed'] ?? false,
      usedByUserId: data['usedByUserId'],
      usedAt: (data['usedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'createdBy': createdBy,
      'createdAt': createdAt,
      'expiresAt': expiresAt,
      'isUsed': isUsed,
      'usedByUserId': usedByUserId,
      'usedAt': usedAt,
    };
  }

  @override
  List<Object?> get props => [
    id, createdBy, createdAt, expiresAt,
    isUsed, usedByUserId, usedAt
  ];
}
