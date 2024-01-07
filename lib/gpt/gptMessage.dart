import '../constants.dart';

class GPTMessage {
  Map<String, Object> constructUserGPTMessage(String message) {
    return {
      "model": Constants.GPTMODEL,
      "messages": [
        {"role": "user", "content": message}
      ]
    };
  }
}
