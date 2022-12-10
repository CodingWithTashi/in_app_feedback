import 'package:flutter_app_feedback/model/github_config.dart';
import 'package:http/http.dart';

import '../constant.dart';

class GitHubHelper {
  static Future<int> createIssue({required GitHubConfig gitHubConfig}) async {
    Map<String, String> headers = {};
    headers["Authorization"] = "Bearer ${gitHubConfig.accessToken}";
    headers["Content-Type"] = "application/vnd.github+json";

    var url =
        '$kGitHubUrl/${gitHubConfig.githubUserName}/${gitHubConfig.repositoryName}/issues';
    var response = await post(Uri.parse(url), headers: headers, body: {
      "title": "Found a bug",
      "body": "Im having a problem with this.",
      "labels": ["bug"]
    });
    return response.statusCode;
  }
}
