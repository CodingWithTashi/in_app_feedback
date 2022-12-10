import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_app_feedback/feedback_date.dart';
import 'package:http/http.dart';

import '../constant.dart';
import '../model/email_config.dart';

class SendGridHelper {
  static Future<FeedbackData> sendMail(
      {required EmailConfig emailConfig}) async {
    Map<String, String> headers = {};
    headers["Authorization"] = "Bearer ${emailConfig.sendGridToken}";
    headers["Content-Type"] = "application/json";
    try {
      var bodyData = {
        "personalizations": [
          {
            "to": [
              {"email": emailConfig.toMail}
            ]
          }
        ],
        "from": {"email": "didiri8050@eilnews.com"},
        "subject": "Test Message",
        "content": [
          {"type": "text/plain", "value": "test"}
        ]
        // "content": [
        //   {"type": "text/plain", "value": "New user register: "}
        // ]
      };
      var response = await post(Uri.parse(kSendGridUrl),
          headers: headers, body: json.decode(json.encode(bodyData)));
      if (response.statusCode == 200 || response.statusCode == 201) {
        return FeedbackData(
          status: response.statusCode,
          message: "Feedback successfully sent",
        );
      } else {
        var res = json.decode(response.body);
        if (res['errors'] != null) {
          if (kDebugMode) print(res['errors']);
          return FeedbackData(
            status: response.statusCode,
            error: res['errors'][0]['message'],
          );
        } else {
          return FeedbackData(
              status: response.statusCode, message: response.body);
        }
      }
    } catch (e) {
      return FeedbackData(
          status: 500,
          error: e.toString(),
          message: "Something went wrong, please try again later");
    }
  }
}
