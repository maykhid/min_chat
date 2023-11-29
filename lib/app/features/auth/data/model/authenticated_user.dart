import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'authenticated_user.g.dart';

// TODO(maykhid): change this class name

@HiveType(typeId: 0)
class AuthenticatedUser extends HiveObject with EquatableMixin{
  AuthenticatedUser({
    required this.id,
    this.name,
    this.email,
    this.mID,
    this.imageUrl,
  });

  factory AuthenticatedUser.fromMap(Map<String, dynamic> map) =>
      AuthenticatedUser(
        id: map['id'] as String,
        name: map['name'] as String,
        email: map['email'] as String,
        mID: map['mID'] as String,
        imageUrl: map['imageUrl'] as String,
      );

  @HiveField(0)
  final String? name;

  @HiveField(1)
  final String? email;

  @HiveField(2)
  final String? imageUrl;

  @HiveField(3)
  final String? mID;

  @HiveField(4)
  final String id;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mID': mID,
      'imageUrl': imageUrl,
    };
  }

  /// Empty user which represents an unauthenticated user.
  static final empty = AuthenticatedUser(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == AuthenticatedUser.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != AuthenticatedUser.empty;

  @override
  List<Object?> get props => [id, name, email, mID, imageUrl];
}
