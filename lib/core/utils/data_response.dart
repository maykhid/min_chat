enum DataResponseStatus { initial, processing, error, success }

extension DataResponseStatusX on DataResponseStatus {
  bool get isInitial => this == DataResponseStatus.initial;
  bool get isProcessing => this == DataResponseStatus.processing;
  bool get isError => this == DataResponseStatus.error;
  bool get isSuccess => this == DataResponseStatus.success;
}
