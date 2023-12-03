import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:min_chat/app/features/auth/data/model/authenticated_user.dart';
import 'package:min_chat/app/features/chat/data/chat_repository.dart';
import 'package:min_chat/core/di/di.dart';
import 'package:min_chat/core/utils/data_response.dart';

class StartConversationCubit extends Cubit<StartConversationState> {
  StartConversationCubit({ChatRepository? chatRepository})
      : _chatRepository = chatRepository ?? locator<ChatRepository>(),
        super(const StartConversationState.unknown());

  final ChatRepository _chatRepository;

  Future<void> startConversation({
    required String recipientMIdOrEmail,
    required String senderMid,
  }) async {
    final response = await _chatRepository.startConversation(
      recipientMIdOrEmail: recipientMIdOrEmail,
      senderMId: senderMid,
    );

    if (response.isFailure) {
      emit(StartConversationState.failed(message: response.errorMessage));
    } else {
      emit(StartConversationState.done(response: response.data!));
    }
  }
}

class StartConversationState extends Equatable {
  const StartConversationState.unknown() : this._();

  const StartConversationState.processing()
      : this._(status: DataResponseStatus.processing);

  const StartConversationState.done({required MinChatUser response})
      : this._(
          status: DataResponseStatus.success,
          response: response,
        );

  const StartConversationState.failed({String? message})
      : this._(message: message, status: DataResponseStatus.error);

  const StartConversationState._({
    this.message,
    this.response,
    this.status = DataResponseStatus.initial,
  });

  final DataResponseStatus status;
  final MinChatUser? response;
  final String? message;

  @override
  List<Object?> get props => [status, message, response];
}
