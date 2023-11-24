import 'package:equatable/equatable.dart';

class AuthenticatedUser extends Equatable {
  const AuthenticatedUser({
    required this.id,
    this.name,
    this.email,
    this.imageUrl,
  });

  final String? name;
  final String? email;
  final String? imageUrl;
  final String id;

  /// Empty user which represents an unauthenticated user.
  static const empty = AuthenticatedUser(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == AuthenticatedUser.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != AuthenticatedUser.empty;

  @override
  List<Object?> get props => [id, name, email, imageUrl];
}
