import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:in_app_feedback/model/feedback_content.dart';
import 'package:in_app_feedback/model/github_config.dart';

import '../constant.dart';
import '../model/feedback_data.dart';

/// GitHub Issue Helper class to create issue in GitHub
/// read more on https://docs.github.com/en/rest/issues/issues?apiVersion=2022-11-28#create-an-issue
class GitHubHelper {
  static Future<FeedbackData> createIssue({
    required GitHubConfig gitHubConfig,
    required FeedbackContent feedbackContent,
  }) async {
    Map<String, String> headers = {
      "Authorization": "Bearer ${gitHubConfig.accessToken}",
      "Content-Type": "application/vnd.github+json",
    };
    var userEmailText = (feedbackContent.userEmail.isNotEmpty == true)
        ? '\n\n Originally created by ${feedbackContent.userEmail}'
        : '';
    var url =
        '$kGitHubUrl/${gitHubConfig.gitHubUserName}/${gitHubConfig.repositoryName}/issues';
    try {
      var bodyData = {
        "title": feedbackContent.title,
        "body": feedbackContent.description + userEmailText,
        "labels": ["bug"]
      };

      /// return 201 usually
      var response = await post(Uri.parse(url),
          headers: headers, body: json.encode(bodyData));
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
