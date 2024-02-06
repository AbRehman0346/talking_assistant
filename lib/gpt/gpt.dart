import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:usegpt/gpt/gptMessage.dart';
import '../constants.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GPT {
  Future<String> askGPT(String value) async {
    String? key = dotenv.env['GPT_SECRET_KEY'];
    if (key == null){
      return "Sorry! We couldn't get response. we could find gpt key.";
    }
    GPTMessage gptmsg = GPTMessage();
    http.Response response = await http.post(
      Uri.parse(Constants.CHATGPTAPI),
      headers: {
        "Authorization": "Bearer $key",
        "Content-Type": "application/json",
      },
      body: jsonEncode(gptmsg.constructUserGPTMessage(value)),
    );

    return jsonDecode(response.body)["choices"][0]["message"]["content"];
  }
}
