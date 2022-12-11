import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:in_app_feedback/model/feedback_content.dart';
import 'package:in_app_feedback/model/feedback_data.dart';

import '../constant.dart';
import '../model/email_config.dart';

/// SendGrid Email Helper class to sent email via SendGrid
/// read more on https://sendgrid.com/free/

class SendGridHelper {
  static Future<FeedbackData> sendMail({
    required EmailConfig emailConfig,
    required FeedbackContent feedbackContent,
  }) async {
    assert(emailConfig.toMailList.isNotEmpty);

    /// Send grid email standard content format
    /// Check more from https://app.sendgrid.com/guide/integrate WEB API
    String userEmail = feedbackContent.userEmail.isNotEmpty == true
        ? feedbackContent.userEmail
        : 'user';
    var bodyData = {
      "personalizations": [
        {
          "to": emailConfig.toMailList.map((email) => {"email": email}).toList()
        }
      ],
      "from": {"email": emailConfig.fromMail},
      "subject": emailConfig.emailSubject,
      "content": [
        {
          "type": "text/plain",
          "value":
              "Hi there,\n\nWe received a feedback from  $userEmail.\n\nTitle: ${feedbackContent.title}\nDescription: ${feedbackContent.description} \n\n Regards"
        }
      ]
    };

    return await _sendSendGridMail(
        bodyData: bodyData, emailConfig: emailConfig);
  }

  static Future<FeedbackData> _sendSendGridMail(
      {required Map<String, Object> bodyData,
      required EmailConfig emailConfig}) async {
    try {
      Map<String, String> headers = {
        "Authorization": "Bearer ${emailConfig.sendGridToken}",
        "Content-Type": "application/json"
      };
      var response = await post(
        Uri.parse(kSendGridUrl),
        headers: headers,
        body: json.encode(bodyData),
      );

      /// return 202 status usually
      if ([200, 202, 202].contains(response.statusCode)) {
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
