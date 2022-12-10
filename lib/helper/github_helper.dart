import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:flutter_app_feedback/model/github_config.dart';
import 'package:http/http.dart';

import '../constant.dart';
import '../feedback_data.dart';

class GitHubHelper {
  static Future<FeedbackData> createIssue(
      {required GitHubConfig gitHubConfig,
      required String title,
      required TextEditingController description}) async {
    Map<String, String> headers = {};
    headers["Authorization"] = "Bearer ${gitHubConfig.accessToken}";
    headers["Content-Type"] = "application/vnd.github+json";

    var url =
        '$kGitHubUrl/${gitHubConfig.githubUserName}/${gitHubConfig.repositoryName}/issues';
    try {
      var response = await post(Uri.parse(url), headers: headers, body: {
        "title": title,
        "body": description,
        "labels": ["bug"]
      });
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
