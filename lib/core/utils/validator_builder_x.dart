import 'package:form_validator/form_validator.dart';
import 'package:min_chat/core/utils/string_x.dart';

extension ValidationBuilderX on ValidationBuilder {
  ValidationBuilder mId() => add((value) {
        if (!value!.isValidMid) {
          return 'Not a Valid mID';
        }
        return null;
      });
}
