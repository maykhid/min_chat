import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';

/// extension on [List<MinChatUser>] i.e participants of a conversation
extension ParticipantX on List<MinChatUser> {
  /// This basically tries to get the user who is currently
  /// conversing with our current user (client) from our list of available
  /// participants and we only have two participants for conversations.
  ///
  MinChatUser extrapolateParticipantByCurrentUserId(String currentUserId) {
    if (first.id == currentUserId) {
      return last;
    }
    return first;
  }
}
