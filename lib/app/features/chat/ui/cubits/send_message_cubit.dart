import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:min_chat/app/features/chat/data/chat_repository.dart';
import 'package:min_chat/app/features/chat/data/model/group_message.dart';
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
    required String id,
  }) async {
    emit(const SendMessageState.processing());
    final response = await _chatRepository.sendMessage(
      message: message,
      id: id,
    );

    if (response.isFailure) {
      emit(SendMessageState.failed(message: response.errorMessage));
    } else {
      emit(const SendMessageState.done());
    }
  }

  Future<void> sendGroupMessage({
    required GroupMessage message,
    required String id,
  }) async {
    emit(const SendMessageState.processing());
    final response = await _chatRepository.sendGroupMessage(
      message: message,
      id: id,
    );

    if (response.isFailure) {
      emit(SendMessageState.failed(message: response.errorMessage));
    } else {
      emit(const SendMessageState.done());
    }
  }

  Future<void> sendGroupVoiceMessage({
    required GroupMessage message,
    required String id,
    required String filePath,
  }) async {
    emit(const SendMessageState.processing());
    final response = await _chatRepository.sendGroupVoiceMessage(
      message: message,
      id: id,
      filePath: filePath,
    );

    if (response.isFailure) {
      emit(SendMessageState.failed(message: response.errorMessage));
    } else {
      emit(const SendMessageState.done());
      // clear audio file
      _clearTempFile(filePath);
    }
  }

  Future<void> sendVoiceMessage({
    required Message message,
    required String filePath,
    required String id,
  }) async {
    emit(const SendMessageState.processing());
    final response = await _chatRepository.sendVoiceMessage(
      message: message,
      filePath: filePath,
      id: id,
    );

    if (response.isFailure) {
      emit(SendMessageState.failed(message: response.errorMessage));
    } else {
      emit(const SendMessageState.done());
      // clear audio file
      _clearTempFile(filePath);
    }
  }

  /// simple helper function to delete audio recording file
  void _clearTempFile(String filePath) {
    final file = File(filePath);
    if (file.existsSync()) {
      unawaited(file.delete());
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
