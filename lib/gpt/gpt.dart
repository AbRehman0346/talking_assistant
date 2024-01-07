import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:usegpt/gpt/gptMessage.dart';

import '../constants.dart';

class GPT {
  Future<String> askGPT(String value) async {
    GPTMessage gptmsg = GPTMessage();
    http.Response response = await http.post(
      Uri.parse(Constants.CHATGPTAPI),
      headers: {
        "Authorization": "Bearer ${Constants.GPTAuthorizationKey}",
        "Content-Type": "application/json",
      },
      body: jsonEncode(gptmsg.constructUserGPTMessage(value)),
    );

    return jsonDecode(response.body)["choices"][0]["message"]["content"];
  }
}
