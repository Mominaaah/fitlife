// ==============================================================
// FILE: lib/features/profile/models/user_model.dart
// CREATE THIS NEW FILE
// ==============================================================
class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? weight;
  final String? height;
  final String? age;
  final String? profileImageUrl;
  final String? fitnessGoal;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.weight,
    this.height,
    this.age,
    this.profileImageUrl,
    this.fitnessGoal,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'weight': weight,
      'height': height,
      'age': age,
      'profileImageUrl': profileImageUrl,
      'fitnessGoal': fitnessGoal,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from Firestore Map
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      weight: map['weight'],
      height: map['height'],
      age: map['age'],
      profileImageUrl: map['profileImageUrl'],
      fitnessGoal: map['fitnessGoal'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  // Copy with method for updates
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? weight,
    String? height,
    String? age,
    String? profileImageUrl,
    String? fitnessGoal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      weight: weight ?? this.weight,
      height: height ?? this.height,
      age: age ?? this.age,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}