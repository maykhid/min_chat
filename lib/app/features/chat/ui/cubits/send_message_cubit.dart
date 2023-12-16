import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:min_chat/app/features/chat/data/chat_repository.dart';
import 'package:min_chat/app/features/chat/data/model/message.dart';
import 'package:min_chat/core/di/di.dart';
import 'package:min_chat/core/utils/data_response.dart';

class SendMessageCubit extends Cubit<SendMessageState> {
  SendMessageCubit({ChatRepository? chatRepository})
      : _chatRepository = chatRepository ?? locator<ChatRepository>(),
        super(const SendMessageState.unknown());

  final ChatRepository _chatRepository;

  Future<void> sendMessage({
    required Message message,
  }) async {
    emit(const SendMessageState.processing());
    final response = await _chatRepository.sendMessage(
      message: message,
    );

    if (response.isFailure) {
      emit(SendMessageState.failed(message: response.errorMessage));
    } else {
      emit(const SendMessageState.done());
    }
  }
}

class SendMessageState extends Equatable {
  const SendMessageState.unknown() : this._();

  const SendMessageState.processing()
      : this._(status: DataResponseStatus.processing);

  const SendMessageState.done()
      : this._(
          status: DataResponseStatus.success,
        );

  const SendMessageState.failed({String? message})
      : this._(message: message, status: DataResponseStatus.error);

  const SendMessageState._({
    this.message,
    this.status = DataResponseStatus.initial,
  });

  final DataResponseStatus status;
  final String? message;

  @override
  List<Object?> get props => [
        status,
        message,
      ];
}
