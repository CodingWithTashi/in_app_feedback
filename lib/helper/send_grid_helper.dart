import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:flutter_app_feedback/feedback_data.dart';
import 'package:http/http.dart';

import '../constant.dart';
import '../model/email_config.dart';

class SendGridHelper {
  static Future<FeedbackData> sendMail(
      {required EmailConfig emailConfig,
      required String title,
      required TextEditingController description}) async {
    assert(emailConfig.toMailList.isNotEmpty);

    var bodyData = {
      "personalizations": [
        {
          "to": [
            emailConfig.toMailList.map((email) => {"email": email})
          ]
        }
      ],
      "from": {"email": emailConfig.fromMail},
      "subject": emailConfig.emailSubject,
      "content": [
        {
          "type": "text/plain",
          "value":
              "Hi there,We received feedback from a user.\n Title: $title\n Description: $description\n We will update you same\n\n Regards"
        }
      ]
    };

    return _sendSendGridMail(bodyData: bodyData, emailConfig: emailConfig);
  }

  static Future<FeedbackData> _sendSendGridMail(
      {required Map<String, Object> bodyData,
      required EmailConfig emailConfig}) async {
    try {
      Map<String, String> headers = {};
      headers["Authorization"] = "Bearer ${emailConfig.sendGridToken}";
      headers["Content-Type"] = "application/json";
      var response = await post(
        Uri.parse(kSendGridUrl),
        headers: headers,
        body: json.encode(bodyData),
      );
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 202) {
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
        message: "Something went wrong, please try again later",
      );
    }
  }
}
